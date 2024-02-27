import { ChangeDetectorRef, Component, OnInit, ViewChild } from '@angular/core';
import { Router } from '@angular/router';
import { LocalDataSource } from 'ng2-smart-table';
import { PecaModel } from 'src/app/models/PecaModel';
import { PecaService } from 'src/app/services/peca.service';
import { Table } from 'primeng/table';

@Component({
  selector: 'app-peca-table',
  templateUrl: './peca-table.component.html',
  styleUrls: ['./peca-table.component.css']
})
export class PecaTableComponent implements OnInit {
  @ViewChild('dt2') dt2: Table | undefined;
  pecas: PecaModel[] = [];
  public source: LocalDataSource = new LocalDataSource(this.pecas);
  pageTitle: string = 'Peça';

  constructor(
    private pecaService: PecaService,
    private router: Router,
    private cdr: ChangeDetectorRef
  ) {}

  ngAfterViewInit() {
    // console.log('dt2:', this.dt2);
  }

  ngOnInit(): void {
    this.list();
  }

  list(): void {
    this.pecaService.list().subscribe(resp => {
      this.pecas = resp;
      this.source.load(this.pecas);
    });
  }

  novo(): void {
    this.router.navigateByUrl('/peca/novo');
  }

  onCustomAction(event: any): void {
    let peca: PecaModel = event.data;
    console.log(event);
    this.router.navigate([`peca/${peca.idPeca}`]);
  }

  editePeca(peca: PecaModel): void {
    this.router.navigateByUrl(`/peca/editar/${peca.idPeca}`);
  }

  editPeca(id: number): void {
    this.router.navigate(['/peca/editar', id]);
  }

  deletePeca(id: number): void {
    // console.log('deletar peça');
    this.pecaService.delete(id).subscribe(() => {
      this.list();
      // console.log(`Peca ${id} foi deletada`);
    });
  }

  onSearch(event: Event): void {
    const value = (event.target as HTMLInputElement).value;
    console.log('Search value:', value);
    this.dt2?.filterGlobal(value, 'contains');
    console.log('Filtered data:', this.dt2?.value);
    this.cdr.detectChanges(); // trigger change detection
    console.log('test data:', this.dt2?.value);
  }

  adicionarPeca(): void {
    this.router.navigateByUrl(`peca/:id`);
  }
  
}