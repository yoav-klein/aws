# Metrics Explorer
---

The Metrics Explorer allows you to aggregate, filter and visualtize your metrics by tags and properties.

In this example, we'll create several EC2 instances. Those instances will have the following tags: `team` and `environment`
The `team` may be either `yossi` `gadi` or `boris`.
The `environment` will be either `dev` or `prod`.


Run the terraform configuration to apply this.

Next, we'll run varying CPU loads on each of these instances.


Then, we'll explore the CPUUtilization of these instances based on environment, and based on app.




