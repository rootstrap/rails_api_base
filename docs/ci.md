# CI

## Parallelization with Parallel & Knapsack
Knapsack and Parallel gems allow us to run tests in several nodes at the same time, benefiint us in the execution time. Knapsack it parallelizes at node level while Parallel does it at CPU level.

Knapsack splits tests based on an execution time report. In case there are files that were not added in the report, they will all run on the same node and may overload it, so it is strongly recommended to update the report frequently.

## Configuration
In case you want to use this you will need a script that split spec files called `parallel_tests` which sets up the configuration, assuming you have `n_nodes * cpu_cores_quantity`.

On Github Actions you can add any nodes you want using matrix strategy, setting up some variables:

```sh
  ci_node_total: [4]
  # set N-1 indexes for parallel jobs
  # When you run 2 parallel jobs then first job will have index 0, the second job will have index 1 etc
  ci_node_index: [0, 1, 2, 3]
```

To update cpu cores quantity on every onde you can do it by updating this variable:
`PARALLEL_TESTS_CONCURRENCY: 2`

To update tests on local machine you can by executing `KNAPSACK_CI_NODE_TOTAL=4 KNAPSACK_CI_NODE_INDEX=1 PARALLEL_TESTS_CONCURRENCY=2 bundle exec parallel_rspec -n 2 -e './bin/parallel_tests'`. This will run subset of tests files corresponding to second node.

## Generating report
Knapsack report needs to be updated frequently to balance execution time among nodes. This can be done manually by executing:
`knapsack_generate_generate_report: true bundle exec knapsack:rspec`

It is also recommended to generate the report in the CI for a better precision. For this you have available a workflow in Github Actions that triggers the report generation and creates a pull request automatically. This workflow can be scheduled in the frequency you want or even can be manually triggered.

To schedule the cron task you have to do it in `.github/workflows/update_knapsack_report.yml:6`
Now is setted on February 31th so will never run. 

```sh
  - cron: '0 5 31 2 *'    
  # The above cron does not run. Replace with the wanted periodicity.
```
## Coverage
When splitting tests in different nodes each one reports only coverate of a part of the code files are testing.
For this reason a job in the CI is added to sums coverages from all nodes to be uses by SimpleCov. This job will be executed after all nodes have finished and will send the final report to CodeClimate.

For the case of CPU cores we do not need to add extra configuration since the report of each node contains the info of all the cores that have been splited.
