/**
 * Created by dsee on 14.05.16.
 */

/**
 * Set parameter for running Perl Script
 */
function setOutput() {
    //parts of script execution command
    var command = "perl";
    var scriptpath = "/home/dsee/WebstormProjects/FHDownloader/js/script.pl";
    var downloadfile = document.getElementById("url").value;
    var savepath = document.getElementById("save").value;

    /**
     * TODO: Alert Box if non Savepath is set
     */

        //all arguments in array
    var arg = [scriptpath, downloadfile, savepath];
    //execute and write in DOM
    run(command, arg, function (result) {
        document.getElementById('p1').innerHTML = result;
    });
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
function run(cmd, arg, callback) {
    var spawn = require('child_process').spawn;
    var command = spawn(cmd, arg);
    var result ="";
    var lineBuffer = "";
    command.stdout.on('data', function (data) {
        lineBuffer += data.toString();
        var lines = lineBuffer.split("\n");
        for (var i = 0; i < lines.length - 1; i++) {
            var line = lines[i];
            console.log(line);
            move(line);
        }
        lineBuffer = lines[lines.length - 1];
    });
    console.log("result: " + result);
    command.on('exit', function (code) {
        if (code != 0) {
            console.log('Failed: ' + code);
            // alert();
        }
    });

    command.on('close', function (code) {
        return callback(result);
    });
}

function move(width) {
    var elem = document.getElementById("myBar");
    var width = 0;
    var id = setInterval(frame, 10);
    function frame() {
        if (width >= 100) {
            clearInterval(id);
        } else {
            width++;
            elem.style.width = width + '%';
        }
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