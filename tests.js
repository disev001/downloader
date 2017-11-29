/**
 * Created by dsee on 14.05.16.
 */

/**
 * Set parameter for running Perl Script
 */
function setOutput() {
    //parts of script execution command
    var command = "perl";
    var scriptpath = "/home/dsee/WebstormProjects/downloader/test.pl";
    var downloadfile = document.getElementById("url").value;
    var savepath = document.getElementById("save").value;

    /**
     * TODO: Alert Box if non Savepath is set
     */

        //all arguments in array
    var arg = [scriptpath];
    //execute and write in DOM
    console.log("start run");
    run(command, arg);

    console.log("run end");
}
/**
 * Running a shell command with use of child_process spawn
 * and returns it stdout
 *
 * @param cmd
 *        terminal command to execute
 * @param arg
 *          argument of terminal command
 * @param callback
 *      callback for use of command output
 */
function run(cmd, arg) {
    var spawn = require('child_process').spawn;
    var command = spawn(cmd, arg, {detached: true, stdout: 'pipe'});
    command.stdout.setEncoding('utf8');
    command.unref();
    var lineBuffer = "";
    command.stdout.pipe(process.stdout);
    command.stdout.on('data', function (data) {
        var lines = (lineBuffer + data).split("\n");
        if (data[data.length - 1] != '\n') {
            lineBuffer = lines.pop();
            console.log(lineBuffer);
        } else {
            lineBuffer = '';
            console.log(lineBuffer);
            console.log("nothing");
        }
        for (var i = 0; i < lines.length - 1; i++) {
            var line = lines[i];
            console.log(line);
            console.log(line);

            console.log("move");
            move(line);
        }
    });
}
function onLoad(){

}

function move(width) {
    var elem = document.getElementById("myBar");
    if (elem.style.ladoschksayawidth < width) {
        elem.style.width = width + '%';
        console.log(width);
    }
}

/**
 [dsee@localhost ~]$ perl /home/dsee/WebstormProjects/FHDownloader/js/script2.pl
 http://www.doldrums-gc.de/Themes/Skyfall_v1/images/custom/bg.jpg /home/dsee/Bilder/
 Can't locate LWP/Simple.pm in @INC (you may need to install the LWP::Simple module)
 (@INC contains: /home/dsee/perl5/lib/perl5/5.22.1/i386-linux-thread-multi /home/dsee/perl5/lib/perl5/5.22.1
 /home/dsee/perl5/lib/perl5/i386-linux-thread-multi /home/dsee/perl5/lib/perl5 /home/dsee/perl5/lib/perl5/5.22.1/i386-linux-thread-multi
 /home/dsee/perl5/lib/perl5/5.22.1
 /home/dsee/perl5/lib/perl5/i386-linux-thread-multi /home/dsee/perl5/lib/perl5 /usr/local/lib/perl5 /usr/local/share/perl5
 /usr/lib/perl5/vendor_perl /usr/share/perl5/vendor_perl /usr/lib/perl5 /usr/share/perl5 .) at /home/dsee/WebstormProjects/FHDownloader/js/script2.pl line 24.
 BEGIN failed--compilation aborted at /home/dsee/WebstormProjects/FHDownloader/js/script2.pl line 24.
 [dsee@localhost ~]$
 */