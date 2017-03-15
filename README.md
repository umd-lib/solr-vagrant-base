# solr-vagrant

Vagrant base box with Java 8 and Solr 6 on CentOS 6.

## Quick Start

Basic `Vagrantfile` to use this box:

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = 'solr'
  # XXX: since we do not have central hosting location for boxes yet
  #      you will have to build the solr-vagrant base box locally
  #      before using this example
  config.vm.box_url = "file:///apps/git/solr-vagrant/package.box"

  config.vm.hostname = 'solrvagrant'
  config.vm.network "private_network", ip: "192.168.40.222"

  # start Solr (without SSL)
  config.vm.provision "shell", privileged: false, inline: <<-SHELL
    cd /apps/solr/solr && ./control startnossl
  SHELL
end
```

Your Solr instance will be available at <http://192.168.40.222:8984>.

### Enabling HTTPS

It is very simple to enable HTTPS. The base box includes a script to [generate a self-signed HTTPS cert](scripts/https-cert.sh).

Just create a `dist` folder on your host, and add a synced `/apps/dist` folder to the Vagrantfile:

```ruby
# for caching of the HTTPS cert
config.vm.synced_folder "dist", "/apps/dist"
```

Add a shell provisioner to run the `https-cert.sh` script before starting Solr:

```ruby
# create HTTPS cert
config.vm.provision "shell", privileged: false, inline: <<-SHELL
  /apps/solr/scripts/https-cert.sh DNS:solrvagrant,IP:192.168.40.222
SHELL
```

The optional argument to `https-cert.sh` is a comma-separted list of [Subject Alternative Names] to include in the certificate, in addition to `localhost` and `127.0.0.1`. You should make sure these to match the values you set in `config.vm.hostname` and `config.vm.private_network`.

Update the command to start Solr from `startnossl` to just `start`:

```ruby
# start Solr (with SSL)
config.vm.provision "shell", privileged: false, inline: <<-SHELL
  cd /apps/solr/solr && ./control start
SHELL
```

Your Solr instance will be available over HTTPS at <https://192.168.40.222:8984>. 

Note that the first time you visit that URL, your browser will present you with a security warning about the certificate, since it is self-signed. Because the `https-cert.sh` script caches the certificate it generates to the host, after the first time you run `vagrant up`, it should re-use the same certificate generated on the first run.

### Deploying Cores

You can also easily deploy cores from synced folders. These folders can be Git repositories, in which case the [deploy script](scripts/core.sh) uses `git clone`. Otherwise, the deploy script falls back to a recursive copy (`cp -rp`).

The `core.sh` script takes 1 or 2 arguments. The first argument is the path to the core source directory (on the VM). The second argument is the name to use for the core in Solr. If no name is given, it defaults to the basename of the source directory path.

The default cores directory on the VM is `/apps/solr/solr/cores`.

Just add a synced folder pointing to your core:

```ruby
config.vm.synced_folder "/apps/git/my-solr-core", "/apps/git/my-solr-core"
```

And add a shell provisioner to run the `core.sh` script before starting Solr:

```ruby
config.vm.provision "shell", privileged: false, inline: <<-SHELL
  /apps/solr/scripts/core.sh /apps/git/my-solr-core my-solr-core
  # equivalent command that takes the core name from the source path
  /apps/solr/scripts/core.sh /apps/git/my-solr-core
SHELL
```

## Running the Base Box

To run the base box itself, do the following:

```bash
git clone git@github.com:umd-lib/solr-vagrant.git
cd solr-vagrant
# download a Java 8 JDK into the dist folder
vagrant up
```

### Building the Base Box

Bring up the base box as above, then run `vagrant package`.

## License

See the [LICENSE](LICENSE.md) file for license rights and limitations (Apache 2.0).

[Subject Alternative Names]: https://en.wikipedia.org/wiki/Subject_Alternative_Name
