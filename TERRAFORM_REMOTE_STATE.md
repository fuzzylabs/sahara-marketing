# What's this?

Unless you're working on your own you will want to enable remote state when you use Terraform. For more details see here: https://www.terraform.io/docs/state/remote.html

# What do I do?

Terraform offers a number of [backends](https://www.terraform.io/docs/backends/) for remote state. Recently they made their [Terraform Cloud](https://www.hashicorp.com/blog/introducing-terraform-cloud-remote-state-management) service available to all users (previously this was an Enterprise only feature). We'll use that now.

* Signup for an account at https://app.terraform.io/signup/account
* Ensure your username has been added to the [Organisation](https://learn.hashicorp.com/terraform/cloud/tf_cloud_gettingstarted#add-organization-members) specified in [terraform/remote-state.tf](terraform/remote-state.tf)
* Create a security token: https://app.terraform.io/app/settings/tokens
* Create a `~/.terraformrc` file and save the token into it
```
   credentials "app.terraform.io" {
     token = "REPLACE_ME"
   }
```
* Set the correct permissions on the file `chmod 600 ~/.terraformrc`

You've now configured the user credentials to be able to authenticate with Terraform Cloud and collaborate on your Organisations project.

See [terraform/remote-state.tf](terraform/remote-state.tf) to see how the backend is configured.
