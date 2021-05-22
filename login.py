import os
import time
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.image import MIMEImage
from dashboard_exporter import exporter
import mimetypes

os.environ['API_KEY'] = 'NRAK-FQH677810Q2JU2RA3CVJCNQSWHK'
os.environ['GUID'] = 'MjAxODkwfFZJWnxEQVNIQk9BUkR8MTk0MDc1NA'

output = exporter(
    personal_api_key= "NRAK-FQH677810Q2JU2RA3CVJCNQSWHK",
    guid= "MjAxODkwfFZJWnxEQVNIQk9BUkR8MTk0MDc1NA",
    file_type="PNG",
)
content_type = output.headers["content-type"]
extension = mimetypes.guess_extension(content_type)

output_directory = '.'
filename = ('error1')

of = "%s/%s%s" % (output_directory, filename, extension)

with open(of, "wb") as f:
    f.write(output.content)
    f.close()

os.environ['API_KEY'] = 'NRAK-FQH677810Q2JU2RA3CVJCNQSWHK'
os.environ['GUID'] = 'MjAxODkwfFZJWnxEQVNIQk9BUkR8MTcyOTkzMw'

output = exporter(
    personal_api_key= "NRAK-FQH677810Q2JU2RA3CVJCNQSWHK",
    guid= "MjAxODkwfFZJWnxEQVNIQk9BUkR8MTcyOTkzMw",
    file_type="PNG",
)
content_type = output.headers["content-type"]
extension = mimetypes.guess_extension(content_type)

output_directory = '.'
filename = ('error2')

of = "%s/%s%s" % (output_directory, filename, extension)

with open(of, "wb") as f:
    f.write(output.content)
    f.close()
os.environ['API_KEY'] = 'NRAK-FQH677810Q2JU2RA3CVJCNQSWHK'
os.environ['GUID'] = 'MjAxODkwfFZJWnxEQVNIQk9BUkR8MTcyOTkzNg'

output = exporter(
    personal_api_key= "NRAK-FQH677810Q2JU2RA3CVJCNQSWHK",
    guid= "MjAxODkwfFZJWnxEQVNIQk9BUkR8MTcyOTkzNg",
    file_type="PNG",
)
content_type = output.headers["content-type"]
extension = mimetypes.guess_extension(content_type)

output_directory = '.'
filename = ('error3')

of = "%s/%s%s" % (output_directory, filename, extension)

with open(of, "wb") as f:
    f.write(output.content)
    f.close()
os.environ['API_KEY'] = 'NRAK-FQH677810Q2JU2RA3CVJCNQSWHK'
os.environ['GUID'] = 'MjAxODkwfFZJWnxEQVNIQk9BUkR8MTg0NDU0NA'

output = exporter(
    personal_api_key= "NRAK-FQH677810Q2JU2RA3CVJCNQSWHK",
    guid= "MjAxODkwfFZJWnxEQVNIQk9BUkR8MTg0NDU0NA",
    file_type="PNG",
)
content_type = output.headers["content-type"]
extension = mimetypes.guess_extension(content_type)

output_directory = '.'
filename = ('dashboard1')

of = "%s/%s%s" % (output_directory, filename, extension)

with open(of, "wb") as f:
    f.write(output.content)
    f.close()

os.environ['API_KEY'] = 'NRAK-FQH677810Q2JU2RA3CVJCNQSWHK'
os.environ['GUID'] = 'MjAxODkwfFZJWnxEQVNIQk9BUkR8MTg0NDU0OA'

output = exporter(
    personal_api_key= "NRAK-FQH677810Q2JU2RA3CVJCNQSWHK",
    guid= "MjAxODkwfFZJWnxEQVNIQk9BUkR8MTg0NDU0OA",
    file_type="PNG",
)
content_type = output.headers["content-type"]
extension = mimetypes.guess_extension(content_type)

output_directory = '.'
filename = ('dashboard2')

of = "%s/%s%s" % (output_directory, filename, extension)

with open(of, "wb") as f:
    f.write(output.content)
    f.close()
os.environ['API_KEY'] = 'NRAK-FQH677810Q2JU2RA3CVJCNQSWHK'
os.environ['GUID'] = 'MjAxODkwfFZJWnxEQVNIQk9BUkR8MTg0NDU0Nw'

output = exporter(
    personal_api_key= "NRAK-FQH677810Q2JU2RA3CVJCNQSWHK",
    guid= "MjAxODkwfFZJWnxEQVNIQk9BUkR8MTg0NDU0Nw",
    file_type="PNG",
)
content_type = output.headers["content-type"]
extension = mimetypes.guess_extension(content_type)

output_directory = '.'
filename = ('dashboard3')

of = "%s/%s%s" % (output_directory, filename, extension)

with open(of, "wb") as f:
    f.write(output.content)
    f.close()
	
strFrom = 'noreply@usautoparts.com' 
strTo = 'WebOps - GRP Technology <b0d411e0.usautoparts.com@amer.teams.ms>'

# Create the root message and fill in the from, to, and subject headers
msgRoot = MIMEMultipart('related')
msgRoot['Subject'] = ''
msgRoot['From'] = strFrom
msgRoot['To'] = strTo
msgRoot.preamble = 'This is a multi-part message in MIME format.'

# Encapsulate the plain and HTML versions of the message body in an
# 'alternative' part, so message agents can decide which they want to display.
msgAlternative = MIMEMultipart('alternative')
msgRoot.attach(msgAlternative)

msgText = MIMEText('This is plain.')
msgAlternative.attach(msgText)

# We reference the image in the IMG SRC attribute by the ID we give it below
msgText = MIMEText('Alerting Entities<img src="cid:image1"  width="1920" height="900"><img src="cid:image2" width="1920" height="900"><img src="cid:image3" width="1920" height="900">', 'html')
msgAlternative.attach(msgText)

# This example assumes the image is in the current directory
fp = open('error1.png', 'rb')
msgImage1 = MIMEImage(fp.read())
fp.close()

fp = open('error2.png', 'rb')
msgImage2 = MIMEImage(fp.read())
fp.close()

fp = open('error3.png', 'rb')
msgImage3 = MIMEImage(fp.read())
fp.close()

# Define the image's ID as referenced above
msgImage1.add_header('Content-ID', '<image1>')
msgImage2.add_header('Content-ID', '<image2>')
msgImage3.add_header('Content-ID', '<image3>')
msgRoot.attach(msgImage1)
msgRoot.attach(msgImage2)
msgRoot.attach(msgImage3)


# Send the email (this example assumes SMTP authentication is required)
import smtplib
smtp = smtplib.SMTP('mail.usautoparts.com', '25')
smtp.starttls()
smtp.sendmail('noreply@usautoparts.com', strTo, msgRoot.as_string())
smtp.quit() 

strFrom = 'noreply@usautoparts.com' 
strTo = 'WebOps - GRP Technology <b0d411e0.usautoparts.com@amer.teams.ms>'

# Create the root message and fill in the from, to, and subject headers
msgRoot = MIMEMultipart('related')
msgRoot['Subject'] = ''
msgRoot['From'] = strFrom
msgRoot['To'] = strTo
msgRoot.preamble = 'This is a multi-part message in MIME format.'

# Encapsulate the plain and HTML versions of the message body in an
# 'alternative' part, so message agents can decide which they want to display.
msgAlternative = MIMEMultipart('alternative')
msgRoot.attach(msgAlternative)

msgText = MIMEText('This is plain.')
msgAlternative.attach(msgText)

# We reference the image in the IMG SRC attribute by the ID we give it below
msgText = MIMEText('Response Time<br><img src="cid:image1" width="1920" height="900"><img src="cid:image2" width="1920" height="900"><img src="cid:image3" width="1920" height="900">', 'html')
msgAlternative.attach(msgText)

# Image location 
fp = open('dashboard1.png', 'rb')
msgImage1 = MIMEImage(fp.read())
fp.close()

fp = open('dashboard2.png', 'rb')
msgImage2 = MIMEImage(fp.read())

fp.close()

fp = open('dashboard3.png', 'rb')
msgImage3 = MIMEImage(fp.read())
fp.close()


# msgImage definition and attachment
msgImage1.add_header('Content-ID', '<image1>')
msgImage2.add_header('Content-ID', '<image2>')
msgImage3.add_header('Content-ID', '<image3>')
msgRoot.attach(msgImage1)
msgRoot.attach(msgImage2)
msgRoot.attach(msgImage3)

# Send the email (this example assumes SMTP authentication is required)
import smtplib
smtp = smtplib.SMTP('mail.usautoparts.com', '25')
smtp.starttls()
smtp.sendmail('noreply@usautoparts.com', strTo, msgRoot.as_string())
smtp.quit() 