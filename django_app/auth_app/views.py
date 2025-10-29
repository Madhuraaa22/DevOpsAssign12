from django.shortcuts import render, redirect
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from django.http import HttpResponse
from .models import LoginUser
from django.contrib.auth.models import User

def login_view(request):
    if request.method == 'POST':
        username = request.POST.get('username')
        password = request.POST.get('password')
        
        try:
            # Check against our custom LoginUser model
            user_data = LoginUser.objects.get(username=username, password=password)
            # Create or get Django user for session management
            user, created = User.objects.get_or_create(
                username=username,
                defaults={'email': '', 'first_name': '', 'last_name': ''}
            )
            login(request, user)
            return redirect('home')
        except LoginUser.DoesNotExist:
            messages.error(request, 'Invalid username or password')
    
    return render(request, 'auth_app/login.html')

def register_view(request):
    if request.method == 'POST':
        username = request.POST.get('username')
        password = request.POST.get('password')
        
        if LoginUser.objects.filter(username=username).exists():
            messages.error(request, 'Username already exists')
        else:
            LoginUser.objects.create(username=username, password=password)
            messages.success(request, 'Registration successful! Please login.')
            return redirect('login')
    
    return render(request, 'auth_app/register.html')

@login_required
def home_view(request):
    return render(request, 'auth_app/home.html', {'username': request.user.username})

def logout_view(request):
    logout(request)
    return redirect('login')
