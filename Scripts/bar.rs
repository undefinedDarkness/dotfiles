#![feature(array_map, str_split_once)]

// Regex + Command
use regex::Regex;
use std::process::Command;

//const ACTIVE_COLOR: &str = "#84a0c6";
//const BACKGROUND_COLOR: &str = "#1e2132";

// Truncate Text Taken From https://stackoverflow.com/questions/38461429/how-can-i-truncate-a-string-to-have-at-most-n-characters.
fn truncate(s: &str, max_chars: usize) -> &str {
    match s.char_indices().nth(max_chars) {
        None => s,
        Some((idx, _)) => &s[..idx],
    }
}

// Run Commnnd
fn run_command(c: &str) -> String {
    String::from_utf8(
        Command::new("sh")
        .args(&["-c", c])
        .output()
        .expect("Failed to run command")
        .stdout
    ).unwrap()
}

fn get_active_window() -> String {
    format!("0x0{:x}", &run_command("xdotool getactivewindow").trim().parse::<i32>().unwrap_or(100))
}

fn get_window_icon(cn: &str) -> String {
    run_command(&format!("$HOME/Documents/Scripts/Resources/lookup-icon-gtk {}", cn.to_lowercase())).trim().to_string()
}

fn get_window_name(line: &str) -> [String; 3] {
    lazy_static::lazy_static! {
        static ref TERMINAL_WINDOWS: Regex = Regex::new(r"kitty$|bash$|\.St\s|\.tabbed").unwrap();
    }
    
    if TERMINAL_WINDOWS.is_match(line) {
        [&line[0..10], "Terminal", &get_window_icon("terminal")].map(|x| x.to_string())
    } else {
        let data = line.split_whitespace().collect::<Vec<&str>>();
        let class_name = data[2].split_once('.').unwrap().1; 

        // Fallback to class if title doesnt exist.
        if data[4] == "N/A" {
            [data[0], class_name,  &get_window_icon(class_name)].map(|x| x.to_string())
        } else {
            [data[0].to_string(), data[4..].join(" "), get_window_icon(class_name)]
        }
    }

}

// Output Window Names To Polybar.
fn output_windows(current_win: String) -> String {
    
    lazy_static::lazy_static! {
        // Probably need to modify this a bit.
        static ref WINDOWS_BLACKLIST: Regex = Regex::new("stalonetray|xfce4-panel|Picture-in-Picture$|Desktop$|Eww - |Discord Updater$|polybar-main_LVDS-1-1$").unwrap();
    } 

    let mut items: Vec<String> = vec![];
    let wmctrl_output = run_command("wmctrl -x -l");

    // Exclude xfce4-panel and friends.
    let all_windows = wmctrl_output.lines().filter(|line| !WINDOWS_BLACKLIST.is_match(line));
    let all_windows_info = all_windows.map(|line| get_window_name(line)).collect::<Vec<[String; 3]>>();

    for window in &all_windows_info {
       let active = if get_active_window() == window[0] { "active" } else { "" };
       let icon = if window[2].is_empty() { "/home/dnoronha/Documents/Scripts/Resources/rrrr.png" } else { &window[2] };
       items.push(format!("<bar-item active=\"{}\" content=\"{}\" id=\"{}\" icon=\"{}\"/>", active, window[1], &window[0], icon));
    }

    if items.len() <=1 {
        println!("");
    } else {
        println!("<box space-evenly=\"false\" orientation=\"v\">{}</box>", items.join(""));
    }
    current_win 
}



fn main() {
    // Loop & Update Bar.
    let mut last = output_windows(get_active_window());
    loop {
        let e = get_active_window();
        if e != last {
            last = output_windows(e);
        }
    }
}
