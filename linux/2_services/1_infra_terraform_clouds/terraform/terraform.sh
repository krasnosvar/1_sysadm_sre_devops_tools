# terraform state commands
# list all resources from state-file ( state is ok, if local, or configured, if S3)
terraform state list
# remove resource form state-file ( for example if resource deleted via AWS UI and still exists in state)
state rm aws_db_parameter_group.aurora_db_pgs13_param_group
# add resource to state-file
import aws_db_parameter_group.aurora_db_pgs13_param_group dev-db-pgs13-param-group
