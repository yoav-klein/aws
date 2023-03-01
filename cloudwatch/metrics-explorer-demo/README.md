# Metrics Explorer
---

The Metrics Explorer allows you to aggregate, filter and visualtize your metrics by tags and properties.

In this example, we'll create several EC2 instances. Those instances will have the following tags: `team` and `environment`
The `team` may be either `yossi` `gadi` or `boris`.
The `environment` will be either `dev` or `prod`.

## Running the example

### 1. Apply the Terraform configuration
Run the terraform configuration to apply this.

```
export AWS_ACCESS_KEY_ID=xxx
export AWS_SECRET_ACCESS_KEY=abc
export AWS_REGION=us-east-1
./run_tf apply -auto-approve
```

### 2. Create CPU load

Next, we'll run varying CPU loads on each of these instances.
```
./run_workload.sh start
```

Then, we'll explore the CPUUtilization of these instances based on environment, and based on app.

### 3. Stop
You can stop the CPU load:
```
./run_workload.sh stop
```


## Inspecting the Metrics Explorer

See in our Google Docs: AWS -> CloudWatch -> Tasks document, in the "Metrics Explorer - demo 2" section,
there we'll bring screenshots and explanations.

