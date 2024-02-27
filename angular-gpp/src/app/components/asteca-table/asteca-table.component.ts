import { ChangeDetectorRef, Component, OnInit, ViewChild } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { LocalDataSource } from 'ng2-smart-table';
import { MessageService } from 'primeng/api';
import { Table } from 'primeng/table';
import { SolicitacaoAstecaModel } from 'src/app/models/SolicitacaoAstecaModel';
import { AstecaService } from 'src/app/services/asteca.service';

@Component({
  selector: 'app-asteca-table',
  templateUrl: './asteca-table.component.html',
  styleUrls: ['./asteca-table.component.css']
})
export class AstecaTableComponent implements OnInit {

  @ViewChild('dt2') dt2: Table | undefined;
  
  pageTitle: string = 'Asteca';
  public astecas: SolicitacaoAstecaModel[] = [];

  public source: LocalDataSource = new LocalDataSource(this.astecas);

  constructor(
    private astecaService: AstecaService,
    private router: Router,
    private route: ActivatedRoute,
    private cdr: ChangeDetectorRef,
    private messageService: MessageService) 
    {

      
     }

     ngAfterViewInit() {
      // console.log('dt2:', this.dt2);
    }

    ngOnInit(): void {
      this.list();
    }
  
    list(): void {
      this.astecaService.list().subscribe(resp => {
        this.astecas = resp;
        this.source.load(resp);
      });
    }

  adicionarAsteca(){
    this.router.navigateByUrl(`asteca/:id`);
  }

  onCustomAction(event: any): void {
    const asteca: SolicitacaoAstecaModel = event.data;
    console.log(event);
    this.router.navigate([`asteca/${asteca.idAsteca}`]);
  }

  editeAsteca(asteca: SolicitacaoAstecaModel): void {
    this.router.navigateByUrl(`/asteca/editar/${asteca.idAsteca}`);
  }

  deleteAsteca(id: number): void {
    this.astecaService.delete(id).subscribe(() => {
      this.list();
      this.showMessage(`O asteca ${id} foi deletado`);
    });
  }

  showMessage(message: string): void {
    this.messageService.add({
      severity: 'success',
      summary: '',
      detail: message,
      life: 10000
    });
  }

  onSearch(event: Event): void {
    const value = (event.target as HTMLInputElement).value;
    console.log('Search value:', value);
    this.dt2?.filterGlobal(value, 'contains');
    console.log('Filtered data:', this.dt2?.value);
    this.cdr.detectChanges();
    console.log('test data:', this.dt2?.value);
  }


}
