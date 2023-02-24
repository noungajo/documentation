# effectuer un dépôt git

## que faire après avoir developper un projet sans git

```git
echo "# test-environment-flutter" >> README.md
git init
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/noungajo/test-environment-flutter.git
git push -u origin main
```

## faire un dépôt depuis un repository existant

```git
git remote add origin https://github.com/noungajo/test-environment-flutter.git
git branch -M main
git push -u origin main
```

## generate a token with git

To generate a token:

Log into GitHub
 Click on your name / Avatar in the upper right corner 
 Select Settings On the left, 
 Click Developer settings 
 Select Personal access tokens 
 Click Generate new token Give the token a description/name 
 Select the scope of the token I selected repo only to facilitate pull, push, clone, and commit actions 
 Click the link Red more about OAuth scopes for details about the permission sets 
 Click Generate token Copy the token – this is your new password!
