# installation of mysqlclient

## Error message
```shell

Defaulting to user installation because normal site-packages is not writeable
Collecting mysqlclient
  Using cached mysqlclient-2.2.0.tar.gz (89 kB)
  Installing build dependencies ... done
  Getting requirements to build wheel ... error
  error: subprocess-exited-with-error
  
  × Getting requirements to build wheel did not run successfully.
  │ exit code: 1
  ╰─> [22 lines of output]
      Trying pkg-config --exists mysqlclient
      Command 'pkg-config --exists mysqlclient' returned non-zero exit status 1.
      Trying pkg-config --exists mariadb
      Command 'pkg-config --exists mariadb' returned non-zero exit status 1.
      Traceback (most recent call last):
        File "/home/benjojo/.local/lib/python3.8/site-packages/pip/_vendor/pyproject_hooks/_in_process/_in_process.py", line 353, in <module>
          main()
        File "/home/benjojo/.local/lib/python3.8/site-packages/pip/_vendor/pyproject_hooks/_in_process/_in_process.py", line 335, in main
          json_out['return_val'] = hook(**hook_input['kwargs'])
        File "/home/benjojo/.local/lib/python3.8/site-packages/pip/_vendor/pyproject_hooks/_in_process/_in_process.py", line 118, in get_requires_for_build_wheel
          return hook(config_settings)
        File "/tmp/pip-build-env-ugqynz7o/overlay/lib/python3.8/site-packages/setuptools/build_meta.py", line 341, in get_requires_for_build_wheel
          return self._get_build_requires(config_settings, requirements=['wheel'])
        File "/tmp/pip-build-env-ugqynz7o/overlay/lib/python3.8/site-packages/setuptools/build_meta.py", line 323, in _get_build_requires
          self.run_setup()
        File "/tmp/pip-build-env-ugqynz7o/overlay/lib/python3.8/site-packages/setuptools/build_meta.py", line 338, in run_setup
          exec(code, locals())
        File "<string>", line 154, in <module>
        File "<string>", line 48, in get_config_posix
        File "<string>", line 27, in find_package_name
      Exception: Can not find valid pkg-config name.
      Specify MYSQLCLIENT_CFLAGS and MYSQLCLIENT_LDFLAGS env vars manually
      [end of output]
  
  note: This error originates from a subprocess, and is likely not a problem with pip.
error: subprocess-exited-with-error

× Getting requirements to build wheel did not run successfully.
│ exit code: 1
╰─> See above for output.

```
## Solution
The error you encountered while trying to install `mysqlclient` is related to missing dependencies required to build the wheel for the package. The package requires some development headers and libraries related to MySQL/MariaDB, and it seems that the necessary dependencies are not available on your system.

To resolve this issue, you can try the following steps:

1. Install the required system packages:
   For Ubuntu or Debian-based systems:
   ```
   sudo apt-get update
   sudo apt-get install python3-dev default-libmysqlclient-dev
   ```
   For CentOS/RHEL-based systems:
   ```
   sudo yum install python3-devel mysql-devel
   ```

2. Once the necessary system packages are installed, try installing `mysqlclient` again using pip:
   ```
   pip3 install mysqlclient
   ```

3. If you still encounter issues, you can try setting the `MYSQLCLIENT_CFLAGS` and `MYSQLCLIENT_LDFLAGS` environment variables manually before installing:
   ```
   export MYSQLCLIENT_CFLAGS="-I/path/to/mysql/includes"
   export MYSQLCLIENT_LDFLAGS="-L/path/to/mysql/libs -lmysqlclient"
   pip3 install mysqlclient
   ```

Replace `/path/to/mysql/includes` and `/path/to/mysql/libs` with the actual paths to the MySQL/MariaDB development header files and libraries on your system.

By following these steps, you should be able to successfully install `mysqlclient` for Python. If you face any further issues, please let me know and provide additional details about your operating system and environment.
