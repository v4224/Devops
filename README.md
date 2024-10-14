#Terraform
1. Cài đặt AWS CLI
2. Cấu hình thông tin xác thực: aws configure

Nhập thông tin:

	AWS Access Key ID: Khóa truy cập AWS.
	AWS Secret Access Key: Khóa bí mật của AWS.
	Default region name: Vùng mặc định (ví dụ: us-east-1).
	Default output format: Định dạng kết quả (json, text hoặc table).

5. Khởi tạo Terraform: terraform init
6. Kiểm tra kế hoạch triển khai: terraform plan
7. Thực hiện triển khai: terraform apply
8. Xóa tài nguyên khi không cần dùng nữa: terraform destroy

#CloudFormation
- Có thể dùng giao diện của AWS để tạo stack cloudformation hoặc AWS CLI
*AWS CLI:
1. Tạo stack:
 --   aws cloudformation create-stack --stack-name MyStack --template-body file://template.yaml
 -        --stack-name: Tên của CloudFormation stack.
 -        --template-body: Đường dẫn đến file CloudFormation template.
3. Kiểm tra trạng thái:
-   aws cloudformation describe-stacks --stack-name MyStack
4. Cập nhật stack (nếu có thay đổi trong file yaml):
-   aws cloudformation update-stack --stack-name MyStack --template-body file://template.yaml
5. Xóa stack:
-   aws cloudformation delete-stack --stack-name MyStack
