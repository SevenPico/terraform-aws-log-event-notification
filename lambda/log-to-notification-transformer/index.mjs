import { unzipBase64 } from './functions/unzip-base64.mjs';
import { generateChatbotLogEvent } from './functions/generate-chatbot-log-event.mjs';
import { parseMessage } from './functions/parse-message.mjs';
import { publishToSNSTopic } from './functions/publish-to-sns-topic.mjs';
import { FF_ENABLE_SNS_PUBLISH } from './constants/index.mjs'

export const handler = async (event) => {
  const decodedEvent = JSON.parse(await unzipBase64(event.awslogs.data));
  console.log(decodedEvent);
  
  const logEvent = decodedEvent?.logEvents?.[0];
  if (!logEvent?.message) return;
  
  const parsedData = parseMessage(logEvent.message);
  const cloudWatchEventData = {
    timestamp: logEvent.timestamp,
    logGroup: decodedEvent.logGroup,
    logStream: decodedEvent.logStream,
  }
  const generatedEvent = generateChatbotLogEvent({
    parsedData, 
    cloudWatchEventData
  });
  
  if( FF_ENABLE_SNS_PUBLISH ) {
    await publishToSNSTopic(generatedEvent, parsedData.logType);
  }
  const response = {
    statusCode: 200,
    body: JSON.stringify('Hello from Lambda!'),
  };
  return response;
};
