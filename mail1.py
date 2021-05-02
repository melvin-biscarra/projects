# Send an HTML email with an embedded image and a plain text message for
# legacy clients.
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.image import MIMEImage

# Define these once; use th
#'b0d411e0.usautoparts.com@amer.teams.ms'
#'melvinbiscarra25@gmail.com'.
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
msgText = MIMEText('Response Time<img src="cid:image1"  width="1920" height="900"><img src="cid:image2" width="1920" height="900"><img src="cid:image3" width="1920" height="900">', 'html')
msgAlternative.attach(msgText)

# This example assumes the image is in the current directory
fp = open('dashboard1.png', 'rb')
msgImage1 = MIMEImage(fp.read())
fp.close()

fp = open('dashboard2.png', 'rb')
msgImage2 = MIMEImage(fp.read())
fp.close()

fp = open('dashboard3.png', 'rb')
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

