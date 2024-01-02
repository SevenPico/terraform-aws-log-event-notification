import { REGION, ACCOUNT_NUMBER, DEPLOYMENT_ENVIRONMENT } from '../constants/index.mjs';

export function generateChatbotLogEvent({ parsedData, cloudWatchEventData }) {
  const { connectorName, timeOfError, connector, taskId, errorMessage, errorSource } = parsedData;

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
    // metadata: {
    //   summary: `Error in MSK Connector: ${connectorName}, region: ${REGION} `,
    //   eventType: "Error",
    //   relatedResources: []
    // }
  };
  console.log(JSON.stringify(logEvent, null, 2));

  return logEvent;
}

function getTitle({ logType }) {
  switch (logType) {
    case 'ERROR':
      return `🚩 [Error] Msk connector throw an exception | ${REGION} | ${ACCOUNT_NUMBER}`;
    case 'INFO':
      return `ℹ️ [Info] Msk connector is <todo: Detect state of the connector from logs> | ${REGION} | ${ACCOUNT_NUMBER}`;
    case 'WARN':
      return `⚠️ [Warn] Msk connector threw a warning | ${REGION} | ${ACCOUNT_NUMBER}`;
    default:
      return "😕 MSK connector emmited an unrecognised log | ${REGION} | ${ACCOUNT_NUMBER}";
  }
}

function getDescription({ connectorName, timeOfOrigin, connector, taskId, messageText, errorSource, logType, originalMessage }, cloudWatchEventData) {
  switch (logType) {
    case 'ERROR':
    case 'INFO':
    case 'WARN':
      return `
> Timestamp: 
> ${cloudWatchEventData.timestamp}

> Enviornment: 
> ${DEPLOYMENT_ENVIRONMENT}

> Connector Name:
> ${connectorName}

\`\`\`${messageText}\`\`\`
`;
    default:
      return "```" + originalMessage + "```"
  }
}
