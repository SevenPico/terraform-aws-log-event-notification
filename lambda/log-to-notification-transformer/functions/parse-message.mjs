export function parseMessage (logMessage){
  const regexPattern = /(?<logType>[A-Z]+) (?<messageText>.*?)$/;
  const matchResult = logMessage.match(regexPattern);
  if (!(matchResult?.groups)) return false;
  return { ...matchResult.groups, originalMessage: logMessage};
}