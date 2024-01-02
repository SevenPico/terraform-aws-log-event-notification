export const REGION = process.env.REGION || "us-east-1";
export const ERROR_SNS_TOPIC_ARN = process.env.SNS_TOPIC_ARN || "arn:aws:sns:us-east-1:276872744862:costa-msk-poc-error-notifications";
export const INFO_SNS_TOPIC_ARN = process.env.SNS_TOPIC_ARN || "arn:aws:sns:us-east-1:276872744862:costa-msk-poc-error-notifications";
export const WARN_SNS_TOPIC_ARN = process.env.SNS_TOPIC_ARN || "arn:aws:sns:us-east-1:276872744862:costa-msk-poc-error-notifications";
export const ACCOUNT_NUMBER = process.env.ACCOUNT_NUMBER || "00000000";
export const DEPLOYMENT_ENVIRONMENT = process.env.DEPLOYMENT_ENVIRONMENT || "prod";


export const FF_ENABLE_SNS_PUBLISH = process.env.FF_ENABLE_SNS_PUBLISH || 1;