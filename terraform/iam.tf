resource "aws_iam_user" "CWLExportUser" {
  name = "CWLExportUser"
}
resource "aws_iam_user_policy_attachment" "CWLExportUser-AmazonS3FullAccess" {
  user       = aws_iam_user.CWLExportUser.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}
resource "aws_iam_user_policy_attachment" "CWLExportUser-CloudWatchLogsFullAccess" {
  user       = aws_iam_user.CWLExportUser.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}
