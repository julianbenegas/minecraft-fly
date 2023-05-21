# minecraft-fly

1. Install fly CLI

```zsh
brew install flyctl
```

2. Install terraform

```zsh
brew tap hashicorp/tap
```

```zsh
brew install hashicorp/tap/terraform
```

3. Set fly token env

```zsh
export FLY_API_TOKEN=$(flyctl auth token) # flyctl will get the auth token
```

4. Run `terraform apply` to deploy to fly
