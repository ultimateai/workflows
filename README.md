# Central workflows repository

This project contains all the callable workflows for Ultimate - made public because of github limitations. With time it would be an interesting opensource project. 

## Quick start

For calling any of this workflows, just choose the situation in which you want them to be called and shoot. Example of caller workflow:

```
name: "Open PR to main branch"

on:
 pull_request:
   branches:
     - main

jobs:
  test_build:
    uses: ultimateai/workflows/.github/workflows/open-pr.yml@main
    secrets: inherit
```

## Workflows and inputs

-   `open-pr.yml`: This actions will happen whenever you open a PR agains main, and it will do some basic checks - npm i, npm test, docker build. Doesn't require any input. 
-   `merged-pr.yml`: TThis action will happen whenever you successfully merge a PR into main, and will bump the release on your repo, build and push the image with the updated tag and, finally, automatically deploy to development environment (as long as your app exists in k8s-manifest repo!). Note on bumping version: Bumping will be major (1.0.0-->2.0.0), minor(1.0.0-->1.1.0) or patch(1.0.0-->1.0.1) depending on the wording of your _LAST_ commit. Default behaviour is patch. 
Input needed:
    - image_repo: container registry (like eu.gcr.io/ultimateai-169214)
    - app_squad: folder inside k8s-repo containing your kustomize code (backend, qa, ia...)
    - github_email: automatic bot email for commiting 
    - github_user: automatic bot user for commiting 
    - k8s_manifests_repo: {organization}/{repo} containing your argoCD-linked repo like ultimateai/k8s-manifests
-   `manual-deploy.yml`: This action will deploy a selected version to a selected environment. If version is not provided, it will deploy the latest release =)
Input needed:
    - image_repo: container registry (like eu.gcr.io/ultimateai-169214)
    - app_squad: folder inside k8s-repo containing your kustomize code (backend, qa, ia...)
    - environment: In which environment do you want to deploy
    - version: Which tag do you want to deploy - if none, latest release will be used. Only allowed_users can do this 🟣
    - github_email: automatic bot email for commiting 
    - github_user: automatic bot user for commiting 
    - k8s_manifests_repo: {organization}/{repo} containing your argoCD-linked repo like ultimateai/k8s-manifests
    - allowed_users: comma-separated list of users allowed to deploy specific versions (user1,user2,user3) 🟣
    🟣 Version and allowed_users are optional - just mind that, if allowed_users is empty, no one will be able to deploy specific versions =)

## Important limitations
1. Only chaper leads can deploy a version different from the latest one 🔴
2. If you try to deploy a version in production which is NOT deployed in staging, workflow will fail 🔴


## TODO
1. Adequate version bumping (with our own script/action)
2. Python support
3. Commit format validation - https://github.com/amannn/action-semantic-pull-request https://www.conventionalcommits.org/en/v1.0.0/
4. Lint and verify k8s repo - https://github.com/devxp-tech/gitops/blob/main/.github/workflows/main.yaml
