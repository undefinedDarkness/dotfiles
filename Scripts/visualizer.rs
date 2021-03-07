#![allow(non_snake_case)]

use std::fs;
use std::io::BufRead;
use std::process::Command;

fn main() {
    // Modify.
    let bars = std::env::args().nth(1).unwrap_or_else(|| { eprintln!("\u{1b}[1m\u{1b}[31mERROR:\u{1b}[0m No bars specified"); 10.to_string()});
    let barMaxHeight = 100;
    let frameRate = 30;

    eprintln!("\u{1b}[1m\u{1b}[34mINFO:\u{1b}[0m Using {} bars.", bars);

    // Basic config.
    let cavaConfigPath ="/tmp/cava_config_for_visualizer";
    let cavaConfig = format!("
[general]
bars = {}
framerate = {}

[output]
method = raw
raw_target=/dev/stdout
data_format=ascii
ascii_max_range={}
bar_delimiter = 59
frame_delimiter = 10
", bars, frameRate, barMaxHeight);
    
    fs::write(&cavaConfigPath, &cavaConfig).expect("Failed to write cava config file.");

    let mut cavaProcess = Command::new("cava")
        .arg("-p")
        .arg(&cavaConfigPath)
        .stdout(std::process::Stdio::piped())
        .spawn().expect("Failed to run cava, its probably not installed.");
    let cavaStdout = std::io::BufReader::new(cavaProcess.stdout.take().unwrap());

    // Infinite Loop.
    for line in cavaStdout.lines() {

        let data = line.expect("Failed to read line.");
        let mut out = String::from("<box space-evenly=\"false\">");
        for (i, v) in data.split(';').enumerate() {
            if i+1 == bars.parse::<usize>().unwrap()+1 {
                break
            }
           out.push_str(format!("<visualizer-bar bar_height=\"{}\" />", v).as_str()) 
        }
        println!("{}</box>", out);
    }
}
