#!/bin/bash
rsync -vuarP krasnosvarov_dn@katello-test:/etc /usr/git/unix_admins/foreman/katello-test-configs/katello-test.corp.domain.ru

rsync -vuarP krasnosvarov_dn@v00sccmgk01tst.corp.domain.ru:/etc /usr/git/unix_admins/foreman/katello-test-configs/v00sccmgk01tst.corp.domain.ru

cd /usr/git/unix_admins/foreman
git add .
git commit -m "execution cron-script to renew git-repo on it-krasnosvarov"
git push
