import { SNSClient, PublishCommand } from '@aws-sdk/client-sns';

import { ERROR_SNS_TOPIC_ARN, INFO_SNS_TOPIC_ARN, WARN_SNS_TOPIC_ARN, REGION } from '../constants/index.mjs';

const snsClient = new SNSClient({
  region: REGION,
});

const selectArn = (messageType) => {
  switch (messageType) {
    case 'ERROR':
      return ERROR_SNS_TOPIC_ARN;
      case 'INFO':
      return INFO_SNS_TOPIC_ARN
      case 'WARN':
      return WARN_SNS_TOPIC_ARN
  }
}
export async function publishToSNSTopic (message, logType) {
  const TopicArn=selectArn(logType);
  if(!TopicArn) {
    console.warn(`Unknown logType: ${logType} `);
    return
  }
  
  const params = {
    TopicArn,
    Message: JSON.stringify(message)
  };

  const publishCommand = new PublishCommand(params);

  try {
    const data = await snsClient.send(publishCommand);
    console.log("Message published to SNS successfully:", data.MessageId);
    return data;
  } catch (err) {
    console.error("Error publishing message to SNS:", err);
    throw err;
  }
};
