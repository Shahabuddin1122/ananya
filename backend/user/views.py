from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status

from .models import User, SuperUser, Questionnaire, PeriodHistory, PeriodPrediction
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
            # Handling SuperUser creation
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
                if user.is_superuser:
                    superuser = SuperUser.objects.get(user_id=user.id)
                    serializer = SuperUserSerializer(superuser)
                    return Response(serializer.data, status=status.HTTP_200_OK)
                else:
                    serializer = UserSerializer(user)
                    return Response(serializer.data, status=status.HTTP_200_OK)
            else:
                return Response({"error": "Invalid credentials"}, status=status.HTTP_401_UNAUTHORIZED)
        except User.DoesNotExist:
            return Response({"error": "User not found"}, status=status.HTTP_404_NOT_FOUND)


@api_view(['POST'])
def add_user_in_superuser(request):
    if request.method == 'POST':
        superuser_id = request.data.get('superuser_id')

        try:
            superuser = SuperUser.objects.get(id=superuser_id)
        except SuperUser.DoesNotExist:
            return Response({"error": "SuperUser not found"}, status=status.HTTP_404_NOT_FOUND)

        user_data = request.data.get('user')

        user = User.objects.filter(email=user_data.get('email')).first()

        if user:
            superuser.managed_users.add(user)
            return Response({"message": "Existing user added to SuperUser successfully"}, status=status.HTTP_200_OK)
        else:
            user_serializer = UserSerializer(data=user_data)
            if user_serializer.is_valid():
                user = user_serializer.save()

                superuser.managed_users.add(user)
                return Response({"message": "New user created and added to SuperUser successfully"},
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
            'cycle_length': questionnaire.days_between_period,
            'anomalies': 'no anomalies',
            'user': user
        }
        PeriodHistory.objects.create(**period_history_data)

        predicted_date = get_period_date(serializer.data)
        if predicted_date:
            period_prediction_data = {
                'period_start_from': predicted_date.get('period_start_from'),
                'period_start_to': predicted_date.get('period_start_to'),
                'anomalies': predicted_date.get('anomalies'),
                'days_between_period': questionnaire.days_between_period,
                'length_of_period': questionnaire.length_of_period,
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
        except Questionnaire.DoesNotExist:
            return Response({'error': 'not able to predict'}, status=status.HTTP_404_NOT_FOUND)
