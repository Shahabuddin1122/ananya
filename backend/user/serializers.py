from rest_framework import serializers

from user.models import User, SuperUser, HealthCondition, Questionnaire, PeriodHistory, PeriodPrediction


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = '__all__'


class SuperUserSerializer(serializers.ModelSerializer):
    user = UserSerializer()
    managed_users = UserSerializer(many=True, required=False)

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


class HealthConditionSerializer(serializers.ModelSerializer):
    class Meta:
        model = HealthCondition
        fields = '__all__'


class QuestionnaireSerializer(serializers.ModelSerializer):
    health_condition = HealthConditionSerializer()

    class Meta:
        model = Questionnaire
        fields = [
            'is_period_regular',
            'days_between_period',
            'length_of_period',
            'last_period_start',
            'take_birth_control',
            'health_condition',
            'user',
        ]

    def create(self, validated_data):
        health_condition_data = validated_data.pop('health_condition')
        health_condition = HealthCondition.objects.create(**health_condition_data)
        questionnaire = Questionnaire.objects.create(health_condition=health_condition, **validated_data)
        return questionnaire

    def update(self, instance, validated_data):
        health_condition_data = validated_data.pop('health_condition')
        health_condition = instance.health_condition

        instance.is_period_regular = validated_data.get('is_period_regular', instance.is_period_regular)
        instance.days_between_period = validated_data.get('days_between_period', instance.days_between_period)
        instance.length_of_period = validated_data.get('length_of_period', instance.length_of_period)
        instance.last_period_start = validated_data.get('last_period_start', instance.last_period_start)
        instance.take_birth_control = validated_data.get('take_birth_control', instance.take_birth_control)
        instance.save()

        for attr, value in health_condition_data.items():
            setattr(health_condition, attr, value)
        health_condition.save()

        return instance


class PeriodHistorySerializer(serializers.ModelSerializer):
    class Meta:
        model = PeriodHistory
        fields = '__all__'


class PeriodPredictionSerializer(serializers.ModelSerializer):
    user = UserSerializer()

    class Meta:
        model = PeriodPrediction
        fields = ['period_start_from', 'period_start_to', 'days_between_period', 'length_of_period', 'anomalies', 'user']
