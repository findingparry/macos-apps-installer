# macos-apps-installer

Bash script to set up a macOS environment by installing essential command-line tools and applications using Homebrew.

```
--------------------------------------------------
Executing the Script:
--------------------------------------------------

1.  **Open Terminal:** Launch the Terminal application (Applications/Utilities).

2.  **Navigate to the Script's Directory:** Use the `cd` command to change the
    current directory to where you saved the script. For example:

    ```bash
    cd Desktop        # If you saved it on your Desktop
    cd ~/scripts     # If you saved it in a "scripts" folder in your home directory
    ```

3.  **Make the Script Executable:**  Use the `chmod` command to give the script
    execute permissions:

    ```bash
    chmod +x setup_env.sh
    ```

4.  **Run the Script:** Execute the script using `./` followed by the script's name:

    ```bash
    ./setup_env.sh
    ```

5.  **Password Prompts:** Be prepared to enter your administrator password when
    prompted.  This is required for installing applications (casks) into
    system directories. The script will pause and wait for you to enter your password.

6.  **Monitor Progress:** The script will print output to the Terminal, showing
    the progress of the installation.  Watch for any error messages (printed in
    red in the improved script).

7.  **Completion:** Once the script finishes, it will print "Installation
    complete!".