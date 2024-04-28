//Run CIDR subnet function for "for loop" to print output values

output subnetValues array=[ for i in range (1,3): cidrSubnet('10.0.0.0/16',24,i)]

// 3:17:37 PM: View deployment in portal: https://portal.azure.com/#blade/HubsExtension/DeploymentDetailsBlade/overview/id/%2Fsubscriptions%2Fdd3a2488-1a34-4741-b1ab-4527b955c565%2FresourceGroups%2FBicep%2Fproviders%2FMicrosoft.Resources%2Fdeployments%2F05-output-values-240428-1104.
//
