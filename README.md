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
    uses: ultimateai/workflows/.github/workflows/ts_open-pr.yml@0.1.2
    with:
      test_command: "npm run test"
    secrets: inherit
```

Mind two things:
1. the _situation_ in which you want your workflow to be called - on pull request, on push, on dispatch... Name of each workflow suggests the situation in which they were think of to be called, so if you decide to invoke them on any other situation, be assured it *won't* have been tested at all =). 
2. The parameters each workflow needs - this is updated fairly frequently, so best way to be sure it's to check each workflow's required inputs!

## Workflows and inputs

-   `deploy-from-branch.yml`: This action is thought to be called manually (as any other deployment), and it allows to deploy the code from any branch of your repository into development (and just development!)
Inputs:
    - test_command: (Optional 🟣) Customizable, by default is npm run test, but can be disabled if set to empy string
    - build_command: (Optional 🟣) Customizable, by default is npm run build, but can be disabled if set to empy string
    - lint_command: (Optional 🟣) Customizable, by default is npm run lint, but can be disabled if set to empy string
    - npm_install_command: (Optional 🟣) Customizable, by default is npm i, but can be disabled if set to empy string
    - app_names: (Optional 🟣) for projects with ONE repo and SEVERAL apps (dashboard-backend, chat-middleware...). Otherwise, leave empty. 
    - node_version: (Optional 🟣) Default is 16.x
    - image_repo: container registry (like eu.gcr.io/ultimateai-169214)
    - app_squad: folder inside k8s-repo containing your kustomize code (backend, qa, ia...)
    - branch_name: branch whose code you want to build and deploy
    - github_email: automatic bot email for commiting 
    - github_user: automatic bot user for commiting 
    - k8s_manifests_repo: {organization}/{repo} containing your argoCD-linked repo like ultimateai/k8s-manifests
-   `open-pr.yml`: This actions will happen whenever you open a PR agains main, and it will do some basic checks - npm i, npm test, docker build.
Input:
    - test_command: (Optional 🟣) Customizable, by default is npm run test, but can be disabled if set to empy string
    - build_command: (Optional 🟣) Customizable, by default is npm run build, but can be disabled if set to empy string
    - lint_command: (Optional 🟣) Customizable, by default is npm run lint, but can be disabled if set to empy string
    - npm_install_command: (Optional 🟣) Customizable, by default is npm i, but can be disabled if set to empy string
    - node_version: (Optional 🟣) Default is 16.x
-   `merged-pr.yml`: TThis action will happen whenever you successfully merge a PR into main, and will bump the release on your repo, build and push the image with the updated tag and, finally, automatically deploy to development or staging environment (as long as your app exists in k8s-manifest repo!). Note on bumping version: Bumping will be major (1.0.0-->2.0.0), minor(1.0.0-->1.1.0) or patch(1.0.0-->1.0.1) depending on the wording of your _LAST_ squased commit. Default behaviour is patch. 
Input needed:
    - image_repo: container registry (like eu.gcr.io/ultimateai-169214)
    - app_squad: folder inside k8s-repo containing your kustomize code (backend, qa, ia...)
    - github_email: automatic bot email for commiting 
    - github_user: automatic bot user for commiting 
    - k8s_manifests_repo: {organization}/{repo} containing your argoCD-linked repo like ultimateai/k8s-manifests
    - update_file: (Optional 🟣) which file, if any, you want to bump alongside the release - currently accepting package.json or version.txt
    - changelog: (Optional 🟣) whether you want to update changelog.md or not, looks like --> 
      ```
      2022-07-29, 21.0.0

        • Commit --> major test (robgutsopedra)
        • Diff --> https://github.com/ultimateai/poc-typescript-app/compare/20.0.0...21.0.0
      2022-07-29, 0.15.1

        • Commit --> Update .env.test (#68) (robgutsopedra)
        • Diff --> https://github.com/ultimateai/poc-typescript-app/compare/0.15.0...0.15.1
      2022-07-29, 0.15.0

        • Commit --> feat: test (robgutsopedra)
        • Diff --> https://github.com/ultimateai/poc-typescript-app/compare/0.14.0...0.15.0
      ```
    - initial_release: (Optional 🟣) In case you don't have any release yet, the release from which bump will happen. Defaults to 0.0.1
    - automatic_deployment_to: (Optional 🟣) the environment, staging or development, in which to automatically deploy. Won't accept any other value =). By default, it's staging - but can be "staging,development" for deploying to both. 
    - test_command: (Optional 🟣) Customizable, by default is npm run test, but can be disabled if set to empy string
    - build_command: (Optional 🟣) Customizable, by default is npm run build, but can be disabled if set to empy string
    - lint_command: (Optional 🟣) Customizable, by default is npm run lint, but can be disabled if set to empy string
    - npm_install_command: (Optional 🟣) Customizable, by default is npm i, but can be disabled if set to empy string
    - node_version: (Optional 🟣) Default is 16.x
-   `manual-deploy.yml`: This action will deploy your latest release to a desired environment (for deploying a specific release, go to rollback!), but make sure you have that version deployed in staging already, or it will fail! Additionally, if you're deploying to staging there is the option to add, after a successful deployment, e2e test launched via testim. 
Input needed:
    - image_repo: container registry (like eu.gcr.io/ultimateai-169214)
    - app_squad: folder inside k8s-repo containing your kustomize code (backend, qa, ia...)
    - environment: In which environment do you want to deploy
    - github_email: automatic bot email for commiting 
    - github_user: automatic bot user for commiting 
    - k8s_manifests_repo: {organization}/{repo} containing your argoCD-linked repo like ultimateai/k8s-manifests
    - run_e2e_tests: Wether to launch of not e2e testim tests - only in case of deployment to staging
    - staging_cluster_name: ultimateai-staging-main-1
    - staging_cluster_location: europe-west1
    - testim_project: 4j2SxviWIdxspepqscef
    - testim_grid: Testim-Grid
    - testim_suite: Which testim suite you want to execute - normally, Critical or Moderate. 
    - testim_additional_flags: Additional CLI parameters for testim, don't touch this parameter too much without your qa team involved "--turbo-mode --parallel 2"
    - slack_channel_id: Slack channel ID where you want your notifications. Can be the ID itself, or the name of the channel. 

-   `rollback.yml`: This action will deploy a selected version to a selected environment. If version is not provided, it will deploy the latest release =)
Input needed:
    - image_repo: container registry (like eu.gcr.io/ultimateai-169214)
    - app_squad: folder inside k8s-repo containing your kustomize code (backend, qa, ia...)
    - environment: In which environment do you want to deploy
    - version: Which tag do you want to rollback to. Mandatory!
    - github_email: automatic bot email for commiting 
    - github_user: automatic bot user for commiting 
    - k8s_manifests_repo: {organization}/{repo} containing your argoCD-linked repo like ultimateai/k8s-manifests
    - allowed_users: comma-separated list of users allowed to deploy specific versions (user1,user2,user3)
    - slack_channel_id: Slack channel ID where you want your notifications. Can be the ID itself, or the name of the channel. 

-   `lint-pr.yml`: This action will happen whenever you open, edit or sync a PR. 
Input needed:   
    - requireScope: (Optional 🟣) Whether scope of PR title is required - feat(SCOPE): subject
    - subjectPattern: (Optional 🟣) Regex for subject of PR title - feat(SCOPE): subject
    - subjectPatternError: (Optional 🟣) Error to show when subject does not match subject regex
    - allowed_types: (Optional 🟣) Types allowed in PR title - TYPE(scope): subject  
      ```
      feat(ui): PLT-000 some explanation of the work you've done.
      ^    ^    ^
      |    |    |__ Subject
      |    |_______ Scope
      |____________ Type
      ```
  

## Important limitations
1. If you try to deploy a version in production which is NOT deployed in staging, workflow will fail 🔴
2. If you try to deploy a version which is already deployed, workflow will kindly warn you, but it won't fail on version 0.15.0+


## TODO
1. Python support
2. Lint and verify k8s repo - https://github.com/devxp-tech/gitops/blob/main/.github/workflows/main.yaml
