from django.test import TestCase
from django.urls import reverse
from django.contrib.auth.models import User
from auth_app.models import LoginUser

class AuthAppTests(TestCase):
    def setUp(self):
        # Create a test user
        self.test_user = LoginUser.objects.create(
            username='ITA733',
            password='2022PE0000'
        )
    
    def test_login_page_loads(self):
        response = self.client.get(reverse('login'))
        self.assertEqual(response.status_code, 200)
        self.assertContains(response, 'Login')
    
    def test_register_page_loads(self):
        response = self.client.get(reverse('register'))
        self.assertEqual(response.status_code, 200)
        self.assertContains(response, 'Register')
    
    def test_user_registration(self):
        response = self.client.post(reverse('register'), {
            'username': 'ITA734',
            'password': '2022PE0001'
        })
        self.assertEqual(response.status_code, 302)  # Redirect after successful registration
        self.assertTrue(LoginUser.objects.filter(username='ITA734').exists())
    
    def test_user_login(self):
        response = self.client.post(reverse('login'), {
            'username': 'ITA733',
            'password': '2022PE0000'
        })
        self.assertEqual(response.status_code, 302)  # Redirect after successful login
    
    def test_home_page_requires_login(self):
        response = self.client.get(reverse('home'))
        self.assertEqual(response.status_code, 302)  # Redirect to login
