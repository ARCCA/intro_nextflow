---
title: "Running on cluster"
teaching: 15
exercises: 15
questions:
- "What configuration should I use to run on a cluster?"
objectives:
- "Understand how to use Slurm specific options"
- "Make sure the correct filesystem is used."
keypoints:
- "Tweak your configuration to make the most of the cluster."
---

We should now be comfortable running on a single local machine such as the login node.  To use the real power of a
supercomputer cluster we should make sure each process is given the required resources.

In the previous section we encountered the concept of a profile.  Lets look at that again.  Lets ignore the
`includeConfig` command for now.

```
profiles {
  slurm {
    executor = 'slurm'
    clusterOptions = '-A scw1001'
  }
}
```

This defines a profile we can use that submits to Slurm using `sbatch` and passes the `clusterOptions`, in this case the
project code used to track the work.

## Specifying resource

The default profiles method in Nextflow handles many things out of the box, for example the `slurm` executor has the
following available:
 
 * **cpus** - the number of cpus to use for the process, e.g. `cpus = 2`
 * **queue** - the partition to use in Slurm, e.g. `queue = 'htc'`
 * **time** - the time limit for the job, e.g. `time = 2d1h30m10s`)
 * **memory** - the amount of memory used for process, e.g. `memory = '2 GB'`
 * **clusterOptions** - the specific arguments to pass to `sbatch`, e.g. `-A scwXXXX`

As you can see most of the usual subjects are there, however if MPI jobs were ever run inside Nextflow the
`clusterOptions` would need to be used to define the number of MPI tasks with `-n` and the `--ntasks-per-node`.  Same
for if GPUs were to be used with `--gres=gpu`

> ## Submission to Slurm
>
> With your current pipeline you should have 4 processes that can run in parallel and a process that depends on all 4
> processes to finish.  Create a Slurm profile and submit your pipeline.  Watch the jobs queue in Slurm with `squeue -u
> $USER`.
> > ## Solution
> > 
> > Following the advice you should be able to use many of the defaults since we are not using parallel code so `ncpus =
> > 1` will be the default.  Just make sure `clusterOptions = "-A scwXXXX"` to specify your project code.
> {: .solution}
{: .challenge}

## Work directory

The work directory where processes are run is by default in the location where you run your job.  This can be changed by
environment variable (not very portable) or by configuration variable.  In `nextflow.config` set the following:

```
workDir = "/scratch/$USER/nextflow/work"
```

This will set a location on `/scratch` to perform the actual work.

The previous option `publishDir` by default symlinks the required output to a convenient location.  This can be changed
by specifying the copy mode.

```
publishDir "$params.outdir", mode: 'copy'
```

> ## Filesystems
>
> Modify the pipeline in `main.nf` to use a working directory in your `/scratch` space and make the data available in
> your `publishDir` location with a new mode such as copy.
> > ## Solution
> > 
> > The solution should be straight forward using information above.
> > 
> > In `nextflow.config`:
> >
> > ```
> > workDir = "/scratch/$USER/nextflow/work"
> > ```
> >
> > In `main.nf`:
> >
> > ```
> > publishDir "$params.outdir", mode: 'copy'
> > ```
> {: .solution}
{: .challenge}

## Module system

The module system on clusters is a convenient way to load common software.  As described before the module can be loaded
by Nextflow before the script is run using the `module` directive.  

```
module 'python'
```

This will load the `python` module which can be loaded normally with

```
$ module load python
```
{: .language-bash}

To load multiple modules such as `python` and `singularity` separate with a colon

```
module 'python:singularity'
```

This has hopefully given you some pointers to configure your Nextflow environment for the cluster.  One aspect of the
cluster is the use of [Singularity](https://www.sylabs.io) to simplify sharing of specific builds of code. Nextflow support the tool
**Singularity** to manage this feature which will shall look at in the next section.

