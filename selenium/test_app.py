#!/usr/bin/env python3
import sys
import time
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options

def test_app(url):
    chrome_options = Options()
    chrome_options.add_argument('--headless')
    chrome_options.add_argument('--no-sandbox')
    chrome_options.add_argument('--disable-dev-shm-usage')
    
    driver = webdriver.Chrome(options=chrome_options)
    
    try:
        # Test login page
        driver.get(f"{url}/login/")
        assert "Login" in driver.title
        print("âœ“ Login page accessible")
        
        # Test register page
        driver.get(f"{url}/register/")
        assert "Register" in driver.title
        print("âœ“ Register page accessible")
        
        print("âœ“ All tests passed!")
        return True
        
    except Exception as e:
        print(f"âœ— Test failed: {e}")
        return False
    finally:
        driver.quit()

if __name__ == "__main__":
    if len(sys.argv) != 3 or sys.argv[1] != "--url":
        print("Usage: python test_app.py --url <base_url>")
        sys.exit(1)
    
    url = sys.argv[2]
    success = test_app(url)
    sys.exit(0 if success else 1)
