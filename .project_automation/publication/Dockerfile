FROM public.ecr.aws/codebuild/amazonlinux2-x86_64-standard:4.0
RUN yum install -y yum-utils && yum-config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo && yum install -y gh
RUN pip install taskcat yq jq awscli
RUN pip3 install 'copier==8.3.0'
RUN pip install 'cfn-lint==0.83.2'
RUN pip install bump2version