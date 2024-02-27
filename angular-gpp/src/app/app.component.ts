import { Component } from '@angular/core';
import { PecaModel } from './models/PecaModel';
import { LocalDataSource } from 'ng2-smart-table';
import { NbMenuItem } from '@nebular/theme';
import { NbMenuService } from '@nebular/theme';
import { takeUntil } from 'rxjs/operators';
import { Subject } from 'rxjs';


@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})

export class AppComponent {
  title = 'agenda';


  items: NbMenuItem[] = [
    {
      title: 'Cadastro',
      expanded: true,
      children: [
        {
          title: 'Peca',
          link: 'pecaList'
        },
        {
          title: 'Teste',
          link: 'teste'
        },
        {
          title: 'login',
          link: 'login'
        },
        
        
      ],
    },
    
  ];  




}
