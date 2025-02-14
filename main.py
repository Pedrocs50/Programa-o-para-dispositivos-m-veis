import flet as ft

def main(page: ft.Page):
    page.title = "Testando"
    text = ft.Text(value="Olá, mundo!", color="red")
    page.controls.append(text)
    page.update()

ft.app(target=main, view=ft.WEB_BROWSER)

