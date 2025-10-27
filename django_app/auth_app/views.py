from django.shortcuts import render, redirect
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.models import User
from django.contrib.auth.decorators import login_required
from django.contrib import messages

def register_view(request):
    if request.user.is_authenticated:
        return redirect('home')
    
    if request.method == 'POST':
        username = request.POST.get('username')
        password = request.POST.get('password')
        
        if not username or not password:
            messages.error(request, 'Both username and password are required.')
            return render(request, 'register.html')
        
        if User.objects.filter(username=username).exists():
            messages.error(request, 'Username already exists. Please choose a different one.')
            return render(request, 'register.html')
        
        try:
            user = User.objects.create_user(username=username, password=password)
            messages.success(request, 'Registration successful! You can now login.')
            return redirect('login')
        except Exception as e:
            messages.error(request, f'Registration failed: {str(e)}')
            return render(request, 'register.html')
    
    return render(request, 'register.html')

def login_view(request):
    if request.user.is_authenticated:
        return redirect('home')
    
    if request.method == 'POST':
        username = request.POST.get('username')
        password = request.POST.get('password')
        
        if not username or not password:
            messages.error(request, 'Both username and password are required.')
            return render(request, 'login.html')
        
        user = authenticate(request, username=username, password=password)
        
        if user is not None:
            login(request, user)
            messages.success(request, 'Login successful!')
            return redirect('home')
        else:
            messages.error(request, 'Invalid username or password.')
            return render(request, 'login.html')
    
    return render(request, 'login.html')

@login_required
def home_view(request):
    return render(request, 'home.html', {'username': request.user.username})

def logout_view(request):
    if request.method == 'POST':
        logout(request)
        messages.success(request, 'You have been logged out successfully.')
        return redirect('login')
    return redirect('home')