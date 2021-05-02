import time
from selenium import webdriver
from selenium.webdriver.firefox.options import Options

options = Options()
options.headless = True
driver = webdriver.Firefox(options=options, executable_path=r'C:\Python27\geckodriver.exe')
driver.get("https://login.newrelic.com/login?return_to=https%3A%2F%2Fone.newrelic.com%2Flauncher%2Fdashboards.launcher%3Fpane%3DeyJuZXJkbGV0SWQiOiJkYXNoYm9hcmRzLmRhc2hib2FyZCIsImVudGl0eUlkIjoiTWpBeE9Ea3dmRlpKV254RVFWTklRazlCVWtSOE1UY3lPVGt6TXciLCJ1c2VEZWZhdWx0VGltZVJhbmdlIjpmYWxzZSwiaXNUZW1wbGF0ZUVtcHR5IjpmYWxzZSwiZWRpdE1vZGUiOmZhbHNlLCJpc1NhdmluZ0VkaXRDaGFuZ2VzIjpmYWxzZX0%3D%26platform%5BaccountId%5D%3D201890%26platform%5B%24isFallbackTimeRange%5D%3Dtrue&login%5Bemail%5D=itopswebops@carparts.com&button=")
time.sleep(10)

driver.find_element_by_id('login_password').send_keys("usap1q2w")
driver.find_element_by_id('login_submit').click()

driver.maximize_window() 
driver.get("https://one.newrelic.com/launcher/dashboards.launcher?pane=eyJuZXJkbGV0SWQiOiJkYXNoYm9hcmRzLmRhc2hib2FyZCIsImVudGl0eUlkIjoiTWpBeE9Ea3dmRlpKV254RVFWTklRazlCVWtSOE1UZzBORFUwTkEiLCJ1c2VEZWZhdWx0VGltZVJhbmdlIjpmYWxzZSwic2VsZWN0ZWRQYWdlIjoiTWpBeE9Ea3dmRlpKV254RVFWTklRazlCVWtSOE1UZzBORFUwTkEiLCJpc1RlbXBsYXRlRW1wdHkiOmZhbHNlfQ==&platform[filters]=ImFjY291bnRJZCA9IDIwMTg5MCI=&platform[accountId]=201890&platform[$isFallbackTimeRange]=false")
time.sleep(10)

total_height = 900
driver.set_window_size(1604, total_height)                                                                                                    
driver.get_screenshot_as_file('dashboard1.png')

driver.maximize_window() 
driver.get("https://one.newrelic.com/launcher/dashboards.launcher?pane=eyJuZXJkbGV0SWQiOiJkYXNoYm9hcmRzLmRhc2hib2FyZCIsImVudGl0eUlkIjoiTWpBeE9Ea3dmRlpKV254RVFWTklRazlCVWtSOE1UZzBORFUwT0EiLCJ1c2VEZWZhdWx0VGltZVJhbmdlIjpmYWxzZSwic2VsZWN0ZWRQYWdlIjoiTWpBeE9Ea3dmRlpKV254RVFWTklRazlCVWtSOE1UZzBORFUwT0EiLCJpc1RlbXBsYXRlRW1wdHkiOmZhbHNlfQ==&platform[filters]=ImFjY291bnRJZCA9IDIwMTg5MCI=&platform[accountId]=201890&platform[$isFallbackTimeRange]=false")
time.sleep(10)

total_height = 900
driver.set_window_size(1604, total_height)                                                                                                    
driver.get_screenshot_as_file('dashboard2.png')

driver.maximize_window() 
driver.get("https://one.newrelic.com/launcher/dashboards.launcher?pane=eyJuZXJkbGV0SWQiOiJkYXNoYm9hcmRzLmRhc2hib2FyZCIsImVudGl0eUlkIjoiTWpBeE9Ea3dmRlpKV254RVFWTklRazlCVWtSOE1UZzBORFUwTnciLCJ1c2VEZWZhdWx0VGltZVJhbmdlIjpmYWxzZSwic2VsZWN0ZWRQYWdlIjoiTWpBeE9Ea3dmRlpKV254RVFWTklRazlCVWtSOE1UZzBORFUwTnciLCJpc1RlbXBsYXRlRW1wdHkiOmZhbHNlfQ==&platform[filters]=ImFjY291bnRJZCA9IDIwMTg5MCI=&platform[accountId]=201890&platform[$isFallbackTimeRange]=false")
time.sleep(15)

total_height = 900
driver.set_window_size(1604, total_height)                                                                                                    
driver.get_screenshot_as_file('dashboard3.png')

driver.maximize_window() 
driver.get("https://one.newrelic.com/launcher/dashboards.launcher?platform[accountId]=201890&platform[$isFallbackTimeRange]=true&pane=eyJuZXJkbGV0SWQiOiJkYXNoYm9hcmRzLmRhc2hib2FyZCIsImVudGl0eUlkIjoiTWpBeE9Ea3dmRlpKV254RVFWTklRazlCVWtSOE1UVTNORGswTUEiLCJ1c2VEZWZhdWx0VGltZVJhbmdlIjpmYWxzZSwic2VsZWN0ZWRQYWdlIjoiTWpBeE9Ea3dmRlpKV254RVFWTklRazlCVWtSOE1UVTNORGswTUEiLCJlZGl0TW9kZSI6ZmFsc2UsImlzVGVtcGxhdGVFbXB0eSI6ZmFsc2UsImlzU2F2aW5nRWRpdENoYW5nZXMiOmZhbHNlfQ==")
time.sleep(15)

total_height = 900
driver.set_window_size(1604, total_height)                                                                                                    
driver.get_screenshot_as_file('APM.png')


driver.maximize_window() 
driver.get("https://one.newrelic.com/launcher/nrai.launcher?pane=eyJuZXJkbGV0SWQiOiJhbGVydGluZy11aS1jbGFzc2ljLmluY2lkZW50cy1hbGwiLCJuYXYiOiJJbmNpZGVudHMiLCJ0eXBlIjoiYWxsIn0=&sidebars[0]=eyJuZXJkbGV0SWQiOiJucmFpLm5hdmlnYXRpb24tYmFyIiwibmF2IjoiSW5jaWRlbnRzIn0=&platform[timeRange][duration]=3600000&platform[accountId]=201890&platform[$isFallbackTimeRange]=false")
time.sleep(15)

total_height = 900
driver.set_window_size(1604, total_height)                                                                                                             
driver.get_screenshot_as_file('Ai.png')

driver.maximize_window() 
driver.get("https://one.newrelic.com/launcher/nrai.launcher?pane=eyJuZXJkbGV0SWQiOiJucmFpLm5yYWktYWktZmVlZCIsIm5hdiI6IkFJIGZlZWQvYW5vbWFsaWVzIn0=&sidebars[0]=eyJuZXJkbGV0SWQiOiJucmFpLm5hdmlnYXRpb24tYmFyIiwibmF2IjoiQUkgZmVlZC9hbm9tYWxpZXMifQ==&platform[timeRange][duration]=3600000&platform[accountId]=201890&platform[$isFallbackTimeRange]=false")

time.sleep(15)

total_height = 900
driver.set_window_size(1604, total_height)                                                                                                             
driver.get_screenshot_as_file('Anomaly.png')

driver.quit() 
 