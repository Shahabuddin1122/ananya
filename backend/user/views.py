from rest_framework.decorators import api_view
from rest_framework.response import Response

from rest_framework import status

from .models import User, SuperUser
from .serializers import UserSerializer, SuperUserSerializer


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
                    return Response(serializer.data, status=status.HTTP_201_CREATED)
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

