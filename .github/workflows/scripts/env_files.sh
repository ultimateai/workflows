if [[ $APP_NAMES == *","* ]]; then
    IFS=',' read -r -a array_app_names <<< "$APP_NAMES"
    for app_name in "${array_app_names[@]}"
        do
        if [[ "${ENVIRONMENT}" = "production" ]]; then
            cat "deployment_envs/$app_name/prod.env" > $HOME/$app_name-envfile.env
        elif [[ "${ENVIRONMENT}" = "staging" ]]; then
            cat "deployment_envs/$app_name/stage.env" > $HOME/$app_name-envfile.env
        else
            cat "deployment_envs/$app_name/dev.env" > $HOME/$app_name-envfile.env
        fi
        if [[ -f "deployment_envs/$app_name/common.env" ]]; then
            echo "Please delete deployment_envs/$app_name/common.env" >> $GITHUB_STEP_SUMMARY
        fi
    done
else
    if [[ "${ENVIRONMENT}" = "production" ]]; then
        cat "deployment_envs/prod.env" > $HOME/envfile.env
    elif [[ "${ENVIRONMENT}" = "staging" ]]; then
        cat "deployment_envs/stage.env" > $HOME/envfile.env
    else
        cat "deployment_envs/dev.env" > $HOME/envfile.env
    fi
    if [[ -f "deployment_envs/common.env" ]]; then
        echo "Please delete deployment_envs/common.env" >> $GITHUB_STEP_SUMMARY
    fi
fi
