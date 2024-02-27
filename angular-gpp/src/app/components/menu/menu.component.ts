import { Component, OnInit } from "@angular/core";
import { Router } from "@angular/router";
import { MenuItem } from "primeng/api";

@Component({
  selector: "app-menu",
  templateUrl: "./menu.component.html",
  styleUrls: ["./menu.component.css"],
})
export class PanelMenuBasicDemoComponent implements OnInit {
  items: MenuItem[] = [];

  constructor(private router: Router) {}

  ngOnInit() {
    this.items = [
      {
        label: "Dashboard",
        icon: "pi pi-fw pi-home",
        command: () => {
          this.router.navigate(["/dashboard"]);
        },
      },
      {
        label: "Peça",
        icon: "pi pi-fw pi-box",
        command: () => {
          this.router.navigate(["/pecaList"]);
        },
      },
      {
        label: "Fornecedor",
        icon: "pi pi-fw pi-user",
        command: () => {
          this.router.navigate(["/fornecedorList"]);
        },
      },
      {
        label: "Produto",
        icon: "pi pi-fw pi-table",
        command: () => {
          this.router.navigate(["/produtoList"]);
        },
      },
      {
        label: "Estoque",
        icon: "pi pi-fw pi-table",
        command: () => {
          this.router.navigate(["/pecaestoqueList"]);
        },
      },
      {
        label: "Asteca",
        icon: "pi pi-fw pi-inbox",
        command: () => {
          this.router.navigate(["/astecaList"]);
        },
      },
    ];
  }
}
