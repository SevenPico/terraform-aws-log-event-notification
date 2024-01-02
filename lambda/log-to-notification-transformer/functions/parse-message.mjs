export function parseMessage (logMessage){
  const regexPattern = /\[(?<connectorName>.*?)\] \[(?<timeOfError>.*?)\] (?<logType>[A-Z]+) \[(?<connector>.*?)\|(?<taskId>.*?)] (?<messageText>.*?)$/;
  const matchResult = logMessage.match(regexPattern);
  if (!(matchResult?.groups)) return false;
  return { ...matchResult.groups, originalMessage: logMessage};
}