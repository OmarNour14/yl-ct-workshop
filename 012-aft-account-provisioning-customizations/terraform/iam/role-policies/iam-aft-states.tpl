{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "states:Start*",
            "Resource": [
                "${alternate_contacts_customizations_sfn_arn}"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "events:PutTargets",
                "events:PutRule",
                "events:DescribeRule"
            ],
            "Resource": [
                "arn:aws:events:${data_aws_region}:${data_aws_account_id}:rule/StepFunctionsGetEventsForStepFunctionsExecutionRule"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "states:DescribeExecution",
                "states:StopExecution"
            ],
            "Resource": "*"
        }
    ]
}
