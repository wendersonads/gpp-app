import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { LocalDataSource } from 'ng2-smart-table';
import { ClienteModel } from 'src/app/models/ClienteModel';

import { ClienteService } from 'src/app/services/cliente.service';

@Component({
  selector: 'app-cliente-list',
  templateUrl: './cliente-list.component.html',
  styleUrls: ['./cliente-list.component.css']
})
export class ClienteListComponent implements OnInit{
  
    public source: LocalDataSource = new LocalDataSource();
  
  
    settings = {
      actions: {
        add: false,
        edit: false,
        delete: false,
        custom: [{ name: 'edit', title: 'Editar' }],
        position: 'right'
      },
      add: false,
      hideHeader: false,
      hideSubHeader: false,
      columns: {
        idCliente: {
          title: 'idCliente',
          type: 'string',
        },
        nome: {
          title: 'nome',
          type: 'string',
        },
        cpfCnpj: {
          title: 'cpfCnpj',
          type: 'string',
        },
        email: {
          title: 'email',
          type: 'string',
        },
        enderecos: {
          title: 'enderecos',
          type: 'string',
        },
        clienteFilial: {
          title: 'clienteFilial',
          type: 'string',
        }

      },
    };  
  
    constructor(private clienteService: ClienteService, private router: Router){}
  
    ngOnInit(): void {
      this.clienteService.list().subscribe(resp => {
        this.source.load(resp);
      });
    }
  
    novo(){
      this.router.navigateByUrl('/cliente/novo');
    }
  
    onCustomAction(event: any) {
      let cliente:ClienteModel = event.data;
      console.log(event);
      this.router.navigate([`cliente/${cliente.idCliente}`]);
    }  
  
  }
  