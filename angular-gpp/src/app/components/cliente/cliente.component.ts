import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { LocalDataSource } from 'ng2-smart-table';
import { ClienteModel } from 'src/app/models/ClienteModel';
import { ClienteService } from 'src/app/services/cliente.service';


@Component({
  selector: 'app-cliente',
  templateUrl: './cliente.component.html',
  styleUrls: ['./cliente.component.css']
})
export class ClienteComponent implements OnInit{

  public cliente:ClienteModel = new ClienteModel();

  public fornecedor: boolean = false;

  


  constructor(private clienteService: ClienteService, private router: Router, private route: ActivatedRoute){}

  ngOnInit(): void {
    this.route.params.subscribe(params => {
      let id = params['id'];
      if(id !== 'novo'){
        this.clienteService.get(id).subscribe(r =>{
          this.cliente = r;
        })
      }
      console.log(id);
    });
  }

  salvar(){
    this.clienteService.add(this.cliente).subscribe(r => {

      this.cliente = new ClienteModel();
      console.log(`funcionou. Nome: `);
      this.router.navigateByUrl('/clienteList');
  
    });
  }


}
