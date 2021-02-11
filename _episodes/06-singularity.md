---
title: "Singularity"
teaching: 15
exercises: 15
questions:
- "How can I quickly reproduce or share my pipelines?"
objectives:
- "Understand how Nextflow uses Singularity to perform tasks."
- "Use Singularity to perform a simple pipeline process."
keypoints:
- "Singularity allows for quick reproduction of common tasks that others have published."
---

Having setup a job using locally installed software, we can instead use software distributed in **containers**.
*Containers* allow for easier management of software due to being able to run the same code across many systems, usually
code is required to be rebuilt for each operating system and hardware.

The most common ways to run containers is to either use [Docker](https://www.docker.io) and [Singularity](https://www.sylabs.io).  Docker can suffer from some issues running on a supercomputer cluster, so it may have
[Singularity](https://www.sylabs.io) installed to allow containers to run.  We will be using **Singularity**.

> ## Singularity training
>
> ARCCA provides a Singularity course if more detailed information how to use Singularity is required.  See list of
> training courses.
{: .callout}

## Using Singularity

Singularity can be specified in the `profiles` section of your configuration such as:

```
profiles {
  slurm { includeConfig './configs/slurm.config' }

  singularity {
    singularity.enabled = true
    singularity.autoMounts = true
  }
}
```

To specify the container to use we can specify it within the `process` in our pipeline.

```
process runPython {
  
  container = 'docker://python'

  output:
  stdout output

  script:
  """
  python --version 2>&1
  """
}

output.subscribe { print "\n$it\n" }

```

Note the use of `subscribe` which allows a function to be used to everytime a value is emitted by the source channel.


The above should output:

```
$ nextflow run main.nf -profile singularity
N E X T F L O W  ~  version 20.10.0
Launching `main.nf` [spontaneous_spence] - revision: 8c50b57f4e
executor >  local (1)
[59/cd3d1e] process > runPython [  0%] 0 of 1

Python 3.9.1
executor >  local (1)
[59/cd3d1e] process > runPython [100%] 1 of 1 ✔
```
{: .output}

Notice the change in Python version.

> ## Compare runs.
>
> Using the simple singularity pipeline, investigate what happens when the `container` directive is removed or commented
> out.
>
> > ## Solution
> >
> > You should see a change in version number when commenting out the container.
> >
> > ```
> > 
> > Python 2.7.5
> > 
> > ```
> > {: .output}
> {: .solution}
{: .challenge}

Using Singularity can remove some of the head-aches of making sure the correct software is installed.  If an existing
pipeline has a container then it should be possible to run it within Singularity inside Nextflow.  Creating your own
container should also be possible if required to share with others.

Having had a bit of a detour to explore some extra options we now go back to the original workflow and explore a few
final things with it.

