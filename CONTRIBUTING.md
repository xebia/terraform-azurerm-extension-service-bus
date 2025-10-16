# XMS Landingzone Extension Template

## Using the template 

1. Create a new repository from this template
2. Develop the terraform module in the `/src` folder
3. Add example module calls in the `/examples` folder
4. In the [XMMS Landingzone Spoke deployment](https://dev.azure.com/xpiritmanagedservices/landingzone-core/_git/spokedeployment-tf?path=/infra/deploy/spoke), add a file named `ext_{extensionname}.tf` which calls the module sourced from the newly created module github repository:

```hcl
module defaults {
    source = "github.com/xebia/xms-landingzone-extension-template//src?ref=v0.0.1"
    resource_group_name = "rg-some-name"
    location = "westeurope"
}
```



