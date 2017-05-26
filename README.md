# CopyPasta
![](http://i.imgur.com/mGSpXT7.jpg)

CopyPasta concurrently copies file and directories from one place to another using threads. This can speed up copying large directory trees when the destination supports high concurrency writes. One example of file system that supports high concurrency writes is [Amazon's Elastic File System](https://aws.amazon.com/efs/).

```
Usage: exe/copy_pasta [options]
    -s, --source-directory=DIRECTORY The source directory to copy from
    -d, --destination-dir=DIR        Directory to copy files to
    -n, --num-threads=THREADS        Number of threads to use for extraction (Default: 100)
    -p, --pattern=PATTERN            Extract files that match the ruby Regexp PATTERN
```
# Examples

Copy all files from one directory to another using 100 threads.

```
copy_pasta -s /tmp/wordpress/wp-content -d /home/user/public_html  -n 100
```

Copy all files matching the pattern from one directory to another.

```
copy_pasta -s /tmp/wordpress/wp-content -d /home/user/public_html -p '\A(plugins|themes|uploads)'
```
