############################################################################################
# Copyright 2019 Palo Alto Networks.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
############################################################################################

output "bucket-name" {
    value = "${aws_s3_bucket.terraform-state-bucket.bucket}"
    description = "Terraform remote state S3 bucket name"
}

output "table-name" {
    value = "${aws_dynamodb_table.terraform-lock-dynamodb.name}"
    description = "Terraform state lock DynamoDB table name"
}
