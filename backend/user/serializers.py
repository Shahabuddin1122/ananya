from rest_framework import serializers

from user.models import User, SuperUser


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = '__all__'


class SuperUserSerializer(serializers.ModelSerializer):
    user = UserSerializer()
    managed_users = UserSerializer(many=True,required=False)

    class Meta:
        model = SuperUser
        fields = ['id', 'user', 'managed_users']

    def validate(self, data):
        # Validate the nested user data
        user_data = data.get('user')
        user_serializer = UserSerializer(data=user_data)
        if not user_serializer.is_valid():
            raise serializers.ValidationError(user_serializer.errors)
        return data

    def create(self, validated_data):
        user_data = validated_data.pop('user')
        managed_users_data = validated_data.pop('managed_users', [])

        # Create the User instance
        user = User.objects.create(**user_data)

        # Create the SuperUser instance
        superuser = SuperUser.objects.create(user=user)

        # Add managed users if provided
        for managed_user_data in managed_users_data:
            managed_user = User.objects.create(**managed_user_data)
            superuser.managed_users.add(managed_user)

        return superuser
