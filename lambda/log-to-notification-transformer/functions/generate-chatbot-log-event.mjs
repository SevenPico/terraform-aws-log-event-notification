import { REGION, ACCOUNT_NUMBER, DEPLOYMENT_ENVIRONMENT } from '../constants/index.mjs';

export function generateChatbotLogEvent({ parsedData, cloudWatchEventData }) {

  const dateFilter =`$3Fstart$3D${cloudWatchEventData.timestamp}$26end$${cloudWatchEventData.timestamp+1000}`;
  const cloudWatchLogsLink = `https://console.aws.amazon.com/cloudwatch/home?region=${REGION}#logsV2:log-groups/log-group/${encodeURIComponent(cloudWatchEventData.logGroup)}/log-events/${encodeURIComponent(cloudWatchEventData.logStream)}/${dateFilter}`;
  const currentTimeStamp = new Date().getTime();

  const logEvent = {
    version: "1.0",
    source: "custom",
    id: `log-event-${cloudWatchEventData.timestamp}-${currentTimeStamp}`,
    content: {
      textType: "client-markdown",
      title: getTitle(parsedData),
      description: getDescription(parsedData, cloudWatchEventData),
      nextSteps: [cloudWatchLogsLink],
      keywords: [],
    },
  };
  console.log(JSON.stringify(logEvent, null, 2));

  return logEvent;
}

function getTitle({ logType }) {
  switch (logType) {
    case 'ERROR':
      return `🚩 [Error] There was an Exception | ${REGION} | ${ACCOUNT_NUMBER}`;
    case 'INFO':
      return `ℹ️ [Info] | ${REGION} | ${ACCOUNT_NUMBER}`;
    case 'WARN':
      return `⚠️ [Warn] There was a warning | ${REGION} | ${ACCOUNT_NUMBER}`;
    default:
      return `😕 Unrecognised log | ${REGION} | ${ACCOUNT_NUMBER}`;
  }
}

function getDescription({ messageText, logType, originalMessage }, cloudWatchEventData) {
  switch (logType) {
    case 'ERROR':
    case 'INFO':
    case 'WARN':
      return `
> Timestamp: 
> ${cloudWatchEventData.timestamp}

> Environment: 
> ${DEPLOYMENT_ENVIRONMENT}


\`\`\`${messageText}\`\`\`
`;
    default:
      return "```" + originalMessage + "```"
  }
}
