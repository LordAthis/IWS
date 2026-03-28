import customtkinter as ctk
import subprocess
import os
from tkinter import messagebox

ctk.set_appearance_mode("dark")
ctk.set_default_color_theme("blue")

class HardeningGUI:
    def __init__(self):
        self.root = ctk.CTk()
        self.root.title("Windows Hardening Telepítő")
        self.root.geometry("700x500")
        
        self.language = "hu"  # hu vagy en
        self.create_widgets()
        
    def create_widgets(self):
        # Cím
        title = ctk.CTkLabel(self.root, text="Windows PC Biztonsági Megerősítés", font=ctk.CTkFont(size=20, weight="bold"))
        title.pack(pady=20)
        
        # Nyelv váltó
        lang_frame = ctk.CTkFrame(self.root)
        lang_frame.pack(pady=5)
        ctk.CTkButton(lang_frame, text="Magyar", width=80, command=self.set_hu).pack(side="left", padx=5)
        ctk.CTkButton(lang_frame, text="English", width=80, command=self.set_en).pack(side="left", padx=5)
        
        # Gombok
        self.btn_core = ctk.CTkButton(self.root, text="Core Hardening (ASR + VBS)", 
                                      command=lambda: self.run_script("harden-windows-core.ps1"))
        self.btn_core.pack(pady=10, padx=50, fill="x")
        
        self.btn_quad9 = ctk.CTkButton(self.root, text="Quad9 + DoH beállítás", 
                                       command=lambda: self.run_script("set-quad9-doh.ps1"))
        self.btn_quad9.pack(pady=10, padx=50, fill="x")
        
        self.btn_usb = ctk.CTkButton(self.root, text="USB tároló blokkolás", 
                                     command=lambda: self.run_script("usb-restriction.ps1"))
        self.btn_usb.pack(pady=10, padx=50, fill="x")
        
        self.btn_browser = ctk.CTkButton(self.root, text="Böngésző megerősítés", 
                                         command=lambda: self.run_script("browser-hardening.ps1"))
        self.btn_browser.pack(pady=10, padx=50, fill="x")
        
        self.btn_autoruns = ctk.CTkButton(self.root, text="Autoruns ellenőrzés", 
                                          command=lambda: self.run_script("check-autoruns.ps1"))
        self.btn_autoruns.pack(pady=10, padx=50, fill="x")
        
        self.btn_full = ctk.CTkButton(self.root, text="TELJES TELEPÍTÉS (mindent sorban)", 
                                      fg_color="green", command=self.run_full_install)
        self.btn_full.pack(pady=20, padx=50, fill="x")
        
        # Info
        info = ctk.CTkLabel(self.root, text="Minden scriptet Administrator módban futtat!", 
                            text_color="yellow")
        info.pack(pady=10)
        
    def set_hu(self):
        self.language = "hu"
        messagebox.showinfo("Nyelv", "Magyar nyelv aktiválva (jelenleg csak a gombok magyarok)")
        
    def set_en(self):
        self.language = "en"
        messagebox.showinfo("Language", "English activated (buttons currently in Hungarian)")
        
    def run_script(self, script_name):
        script_path = os.path.join(os.path.dirname(__file__), "..", "scripts", script_name)
        if os.path.exists(script_path):
            try:
                subprocess.Popen(["powershell.exe", "-ExecutionPolicy", "Bypass", "-File", script_path], 
                                 creationflags=subprocess.CREATE_NEW_CONSOLE)
                messagebox.showinfo("Indítás", f"{script_name} elindítva új ablakban!")
            except Exception as e:
                messagebox.showerror("Hiba", str(e))
        else:
            messagebox.showerror("Hiba", f"Script nem található: {script_name}")
            
    def run_full_install(self):
        full_path = os.path.join(os.path.dirname(__file__), "..", "scripts", "install-hardening.ps1")
        if os.path.exists(full_path):
            subprocess.Popen(["powershell.exe", "-ExecutionPolicy", "Bypass", "-File", full_path], 
                             creationflags=subprocess.CREATE_NEW_CONSOLE)
            messagebox.showinfo("Teljes telepítés", "A teljes hardening folyamat elindult!")
        else:
            messagebox.showerror("Hiba", "install-hardening.ps1 nem található")

if __name__ == "__main__":
    app = HardeningGUI()
    app.root.mainloop()
