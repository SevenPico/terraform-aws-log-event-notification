# Aws Log Events Notification Module 
This module triggers a Lambda whenever there is a pattern match on a Cloudwatch log subscription filter. That lambda then sends a ChatBot Custom Message Schema event to the given SNS topics.

It deploys the following.
- 3 sns topics: For Info, Warning and Error messages.
- Attaches Cloud watch subscription filter to given set of log groups.
- A lambda function, that is triggered by the subscription filter.

> This module Does not include the SNS to Aws Chat-bot connection.  
 