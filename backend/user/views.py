from datetime import date

from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status

from .models import User, SuperUser, Questionnaire, PeriodHistory, PeriodPrediction, HealthCondition
from .serializers import UserSerializer, SuperUserSerializer, QuestionnaireSerializer, PeriodHistorySerializer, \
    PeriodPredictionSerializer
from .utils import *


@api_view(['POST'])
def user_signup(request):
    if request.method == 'POST':
        if not request.data['is_superuser']:
            # Handling regular User creation
            user_data = request.data
            serializer = UserSerializer(data=user_data)
            if serializer.is_valid():
                serializer.save()
                return Response({"message": "User created successfully"}, status=status.HTTP_201_CREATED)
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['POST'])
def super_user_signup(request):
    if request.method == 'POST':
        if request.data['user']:
            superuser_data = request.data
            serializer = SuperUserSerializer(data=superuser_data)
            if serializer.is_valid():
                serializer.save()
                return Response({"message": "SuperUser created successfully"}, status=status.HTTP_201_CREATED)
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['POST'])
def user_login(request):
    if request.method == 'POST':
        phone = request.data.get('phone')
        password = request.data.get('password')

        try:
            user = User.objects.get(phone=phone)
            if user.password == password:
                serializer = UserSerializer(user)
                return Response(serializer.data, status=status.HTTP_200_OK)
            else:
                return Response({"error": "Invalid credentials"}, status=status.HTTP_401_UNAUTHORIZED)
        except User.DoesNotExist:
            return Response({"error": "User not found"}, status=status.HTTP_404_NOT_FOUND)


@api_view(['POST'])
def add_user_in_superuser(request, superuser_id):
    try:
        superuser = SuperUser.objects.get(user_id=superuser_id)
    except SuperUser.DoesNotExist:
        return Response({"error": "SuperUser not found"}, status=status.HTTP_404_NOT_FOUND)

    user_data = request.data

    email = user_data.get('phone')
    if not email:
        return Response({"error": "Email is required"}, status=status.HTTP_400_BAD_REQUEST)

    user = User.objects.filter(email=email).first()

    if user:
        superuser.managed_users.add(user)
        superuser_serializer = SuperUserSerializer(superuser)
        return Response(superuser_serializer, status=status.HTTP_200_OK)
    else:
        # Prepare data for new user
        user_data = {
            'email': email,
            'name': user_data.get('name'),
            'phone': user_data.get('phone'),
            'password': superuser.user.password,
            'is_superuser': False,
            'date_of_birth': user_data.get('date_of_birth', superuser.user.date_of_birth),
            'district': user_data.get('district', superuser.user.district),
            'project': user_data.get('project', superuser.user.project),
        }
        user_serializer = UserSerializer(data=user_data)
        if user_serializer.is_valid():
            user = user_serializer.save()

            superuser.managed_users.add(user)
            superuser_serializer = SuperUserSerializer(superuser)
            return Response(superuser_serializer.data,
                            status=status.HTTP_201_CREATED)

        return Response(user_serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET'])
def get_user(request, user_id):
    if request.method == 'GET':
        users = SuperUser.objects.get(id=user_id)
        serializer = SuperUserSerializer(users)
        return Response(serializer.data, status=status.HTTP_200_OK)
    return Response({"error": "User not found"}, status=status.HTTP_404_NOT_FOUND)


@api_view(['POST'])
def add_period_info(request, user_id):
    try:
        user = User.objects.get(id=user_id)
    except User.DoesNotExist:
        return Response({'error': 'User not found'}, status=status.HTTP_404_NOT_FOUND)

    data = request.data.copy()
    data['user'] = user.id

    serializer = QuestionnaireSerializer(data=data)
    if serializer.is_valid():
        questionnaire = serializer.save()

        period_history_data = {
            'period_start': questionnaire.last_period_start,
            'cycle_length': questionnaire.length_of_period,
            'days_between_period': questionnaire.days_between_period,
            'anomalies': 'Regular',
            'user': user
        }
        PeriodHistory.objects.create(**period_history_data)

        predicted_date = get_period_date(user_id, questionnaire.last_period_start)
        while predicted_date and predicted_date.get('period_start_from') < date.today():
            period_history_data = {
                'period_start': predicted_date.get('period_start_from'),
                'cycle_length': predicted_date.get('length_of_period'),
                'days_between_period': predicted_date.get('days_between_period'),
                'anomalies': predicted_date.get('anomalies', 'Regular'),
                'user': user
            }
            PeriodHistory.objects.create(**period_history_data)

            predicted_date = get_period_date(user_id, predicted_date.get('period_start_from'))

        if predicted_date:
            period_prediction_data = {
                'period_start_from': predicted_date.get('period_start_from'),
                'period_start_to': predicted_date.get('period_start_to'),
                'anomalies': predicted_date.get('anomalies'),
                'days_between_period': predicted_date.get('days_between_period'),
                'length_of_period': predicted_date.get('length_of_period'),
                'user': user
            }
            period_prediction = PeriodPrediction.objects.create(**period_prediction_data)
            serializer = PeriodPredictionSerializer(period_prediction)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        else:
            return Response({'error': 'Unable to predict period dates'}, status=status.HTTP_400_BAD_REQUEST)
    else:
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET'])
def get_user_period_questionnaire(request, user_id):
    try:
        user = User.objects.get(id=user_id)
    except User.DoesNotExist:
        return Response({'error': 'User not found'}, status=status.HTTP_404_NOT_FOUND)

    try:
        questionnaire = Questionnaire.objects.get(user_id=user.id)
        serializer = QuestionnaireSerializer(questionnaire)
        return Response(serializer.data, status=status.HTTP_200_OK)
    except Questionnaire.DoesNotExist:
        return Response({'error': 'Questionnaire not added'}, status=status.HTTP_404_NOT_FOUND)


@api_view(['GET'])
def get_period_prediction(request, user_id):
    if request.method == 'GET':
        try:
            period_prediction = PeriodPrediction.objects.get(user_id=user_id)
            serializer = PeriodPredictionSerializer(period_prediction)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except PeriodPrediction.DoesNotExist:
            return Response({'error': 'not able to predict'}, status=status.HTTP_404_NOT_FOUND)


@api_view(['GET'])
def get_period_history(request, user_id):
    if request.method == 'GET':
        try:
            period_history = PeriodHistory.objects.filter(user_id=user_id).order_by('-period_start')
            if not period_history.exists():
                return Response({'error': 'No period history found'}, status=status.HTTP_404_NOT_FOUND)

            serializer = PeriodHistorySerializer(period_history, many=True)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


@api_view(['PUT'])
def log_new_period(request, user_id):
    if request.method == 'PUT':
        try:
            most_recent_period = PeriodHistory.objects.filter(user_id=user_id).order_by('-period_start').first()

            if not most_recent_period:
                return Response({'error': 'No period history found for the user'}, status=status.HTTP_404_NOT_FOUND)

            updated_last_period_start = request.data.get('last_period_start')
            if updated_last_period_start:
                most_recent_period.period_start = updated_last_period_start
                most_recent_period.save()

            questionnaire = Questionnaire.objects.get(user_id=user_id)
            health_condition_data = request.data.get('health_condition')

            if health_condition_data:
                health_condition, _ = HealthCondition.objects.get_or_create(
                    id=questionnaire.health_condition.id,
                    defaults=health_condition_data
                )
                for attr, value in health_condition_data.items():
                    setattr(health_condition, attr, value)
                health_condition.save()

                questionnaire.health_condition = health_condition
                questionnaire.save()

            predicted_date = get_period_date(user_id, updated_last_period_start)

            period_prediction, created = PeriodPrediction.objects.get_or_create(user_id=user_id)
            period_prediction.period_start_to = predicted_date.get('period_start_to')
            period_prediction.period_start_from = predicted_date.get('period_start_from')
            period_prediction.anomalies = predicted_date.get('anomalies')
            period_prediction.days_between_period = predicted_date.get('days_between_period')
            period_prediction.length_of_period = predicted_date.get('length_of_period')
            period_prediction.save()
            period_prediction_serializer = PeriodPredictionSerializer(period_prediction)
            return Response(period_prediction_serializer.data, status=status.HTTP_201_CREATED)

        except Questionnaire.DoesNotExist:
            return Response({'error': 'Questionnaire not found'}, status=status.HTTP_404_NOT_FOUND)

    return Response({'error': 'Invalid request method'}, status=status.HTTP_405_METHOD_NOT_ALLOWED)


@api_view(['PUT'])
def period_confirmation(request, user_id):
    if request.method == 'PUT':
        # add period history
        period_date = datetime.strptime(request.data.get('period_date'), '%Y-%m-%d').date()

        period_history = PeriodHistory.objects.filter(user_id=user_id).order_by('-period_start').first()
        cycle = (period_date - period_history.period_start).days
        user = User.objects.get(id=user_id)
        period_history_data = {
            'period_start': period_date,
            'days_between_period': cycle,
            'cycle_length': cycle / 4,
            'anomalies': 'Regular' if 25 <= cycle <= 30 else 'Irregular',
            'user': user
        }
        PeriodHistory.objects.create(**period_history_data)

        # delete previous prediction
        PeriodPrediction.objects.filter(user_id=user_id).delete()
        # add new prediction
        period_prediction = get_period_date(user_id, period_date)
        period_prediction_data = {
            'period_start_from': period_prediction.get('period_start_from'),
            'period_start_to': period_prediction.get('period_start_to'),
            'anomalies': period_prediction.get('anomalies'),
            'days_between_period': cycle,
            'length_of_period': period_prediction.get('length_of_period'),
            'user': user
        }
        new_period_prediction = PeriodPrediction.objects.create(**period_prediction_data)
        serializer = PeriodPredictionSerializer(new_period_prediction)
        return Response(serializer.data, status=status.HTTP_200_OK)
    return Response({'error': 'Invalid request method'}, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET'])
def update_period_information(request, user_id):
    try:
        period_data = PeriodPrediction.objects.get(user_id=user_id)
        period_data.period_start_from += timedelta(days=1)
        period_data.period_start_to += timedelta(days=1)
        period_data.save()

        serializer = PeriodPredictionSerializer(period_data)
        return Response(serializer.data, status=status.HTTP_200_OK)

    except PeriodPrediction.DoesNotExist:
        return Response({'error': 'PeriodPrediction data not found for this user'}, status=status.HTTP_404_NOT_FOUND)
    except Exception as e:
        return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET'])
def advance_period_information(request, user_id):
    if request.method == 'GET':
        period_history = (PeriodHistory.objects
                          .filter(user_id=user_id)
                          .order_by('-period_start'))
        previous_period = PeriodPrediction.objects.filter(user_id=user_id)
        most_recent_period = previous_period.first()
        last_period_start = most_recent_period.period_start_from
        period_date = get_period_date(user_id, last_period_start)
        total_period = sum([data.days_between_period for data in period_history])
        total_period_length = sum([data.cycle_length for data in period_history])
        number = period_history.count()
        average_period_cycle = int(total_period / number)
        average_period_length = int(total_period_length / number)
        data = {
            "next_cycle": period_date.get('period_start_from'),
            "average_period_cycle": average_period_cycle,
            "average_period_length": average_period_length,
        }
        return Response(data, status=status.HTTP_200_OK)
    return Response({'error': 'Invalid request method'}, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET'])
def get_all_cohorts(request, superuser_id):
    if request.method == 'GET':
        superuser = SuperUser.objects.get(user_id=superuser_id)
        serializer = SuperUserSerializer(superuser)
        return Response(serializer.data, status=status.HTTP_200_OK)
    return Response({'error': 'Invalid request method'}, status=status.HTTP_400_BAD_REQUEST)
