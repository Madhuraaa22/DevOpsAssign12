import argparse
import time
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.chrome.options import Options

def test_django_app(url):
    # Setup Chrome options
    chrome_options = Options()
    chrome_options.add_argument("--headless")
    chrome_options.add_argument("--no-sandbox")
    chrome_options.add_argument("--disable-dev-shm-usage")
    chrome_options.add_argument("--disable-gpu")
    chrome_options.add_argument("--window-size=1920,1080")
    
    # Initialize driver
    driver = webdriver.Chrome(options=chrome_options)
    
    try:
        print(f"Testing Django application at: {url}")
        
        # Test 1: Access login page
        print("Test 1: Accessing login page...")
        driver.get(f"{url}/login/")
        wait = WebDriverWait(driver, 10)
        
        # Verify login page elements
        username_field = wait.until(EC.presence_of_element_located((By.NAME, "username")))
        password_field = driver.find_element(By.NAME, "password")
        login_button = driver.find_element(By.CSS_SELECTOR, "button[type='submit']")
        
        assert username_field.is_displayed(), "Username field not found"
        assert password_field.is_displayed(), "Password field not found"
        assert login_button.is_displayed(), "Login button not found"
        print("âœ“ Login page elements found")
        
        # Test 2: Test registration
        print("Test 2: Testing registration...")
        register_link = driver.find_element(By.LINK_TEXT, "Register here")
        register_link.click()
        
        # Wait for register page
        wait.until(EC.presence_of_element_located((By.NAME, "username")))
        
        # Fill registration form
        username_field = driver.find_element(By.NAME, "username")
        password_field = driver.find_element(By.NAME, "password")
        register_button = driver.find_element(By.CSS_SELECTOR, "button[type='submit']")
        
        username_field.send_keys("ITA733")
        password_field.send_keys("2022PE0000")
        register_button.click()
        
        # Check for success message
        time.sleep(2)
        print("âœ“ Registration completed")
        
        # Test 3: Test login
        print("Test 3: Testing login...")
        username_field = driver.find_element(By.NAME, "username")
        password_field = driver.find_element(By.NAME, "password")
        login_button = driver.find_element(By.CSS_SELECTOR, "button[type='submit']")
        
        username_field.clear()
        password_field.clear()
        username_field.send_keys("ITA733")
        password_field.send_keys("2022PE0000")
        login_button.click()
        
        # Wait for home page
        wait.until(EC.presence_of_element_located((By.TAG_NAME, "h1")))
        
        # Verify home page content
        welcome_text = driver.find_element(By.TAG_NAME, "h1").text
        assert "Welcome!" in welcome_text, "Welcome message not found"
        
        # Check for personalized message
        body_text = driver.find_element(By.TAG_NAME, "body").text
        assert "Hello ITA733 How are you" in body_text, "Personalized message not found"
        print("âœ“ Login successful and home page displayed correctly")
        
        # Test 4: Test logout
        print("Test 4: Testing logout...")
        logout_button = driver.find_element(By.LINK_TEXT, "Logout")
        logout_button.click()
        
        # Wait for redirect to login page
        wait.until(EC.presence_of_element_located((By.NAME, "username")))
        print("âœ“ Logout successful")
        
        print("\nðŸŽ‰ All tests passed successfully!")
        
    except Exception as e:
        print(f"âŒ Test failed: {str(e)}")
        driver.save_screenshot("test_failure.png")
        raise
    
    finally:
        driver.quit()

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Test Django application")
    parser.add_argument("--url", required=True, help="Base URL of the Django application")
    args = parser.parse_args()
    
    test_django_app(args.url)
